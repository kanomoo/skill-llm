#!/usr/bin/env node
/**
 * Inspo MCP Bridge CLI
 * Allows any agent, subagent, or developer to query the Inspo MCP server directly
 * without needing an active MCP session restart or special client transport.
 */

const https = require('https');

const ENDPOINT = process.env.INSPO_ENDPOINT || 'https://inspomcp.dev/api/mcp';

async function callMcp(toolName, args = {}) {
  const payload = JSON.stringify({
    jsonrpc: '2.0',
    id: Date.now(),
    method: 'tools/call',
    params: {
      name: toolName,
      arguments: args
    }
  });

  return new Promise((resolve, reject) => {
    const req = https.request(ENDPOINT, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json, text/event-stream',
        'Content-Length': Buffer.byteLength(payload)
      }
    }, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          const json = JSON.parse(data);
          if (json.error) {
            reject(new Error(`MCP Error [${json.error.code}]: ${json.error.message}`));
          } else if (json.result && json.result.content) {
            const texts = json.result.content
              .filter(c => c.type === 'text')
              .map(c => c.text)
              .join('\n');
            resolve(texts);
          } else {
            resolve(JSON.stringify(json, null, 2));
          }
        } catch (e) {
          reject(new Error(`Failed to parse response: ${e.message}\nRaw: ${data.slice(0, 200)}`));
        }
      });
    });

    req.on('error', reject);
    req.write(payload);
    req.end();
  });
}

async function listTools() {
  const payload = JSON.stringify({
    jsonrpc: '2.0',
    id: 1,
    method: 'tools/list',
    params: {}
  });

  return new Promise((resolve, reject) => {
    const req = https.request(ENDPOINT, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json, text/event-stream',
        'Content-Length': Buffer.byteLength(payload)
      }
    }, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          const json = JSON.parse(data);
          resolve(json.result.tools);
        } catch (e) {
          reject(e);
        }
      });
    });

    req.on('error', reject);
    req.write(payload);
    req.end();
  });
}

async function main() {
  const [,, command, ...rest] = process.argv;

  if (!command || command === '--help' || command === '-h' || command === 'help') {
    console.log(`
Inspo MCP CLI Bridge

Usage:
  node inspo_cli.js list
      List all available Inspo MCP tools and descriptions.

  node inspo_cli.js recommend "<brief>" [macrostructure]
      Get recommended macrostructure, exemplars, reference components, and palette.
      Example: node inspo_cli.js recommend "modern developer platform landing page"

  node inspo_cli.js find_components <type> [style]
      Find real production websites featuring a specific component.
      Types: hero, pricing, features, cta, nav, footer, testimonial, logo-cloud, faq, stat
      Example: node inspo_cli.js find_components hero minimalism

  node inspo_cli.js find_reference_components [type]
      List canonical reference archetypes.
      Example: node inspo_cli.js find_reference_components hero

  node inspo_cli.js get_reference_jsx <type> <id>
      Fetch clean, production-ready React + Tailwind JSX for a component archetype.
      Example: node inspo_cli.js get_reference_jsx hero documentary

  node inspo_cli.js find_by_color <hexColor>
      Find real sites matching an extracted hex color.
      Example: node inspo_cli.js find_by_color "#4F46E5"

  node inspo_cli.js get_design_system <screenSlug>
      Get full DESIGN.md (fonts, palette, CSS variables, tokens) for a site screen.
      Example: node inspo_cli.js get_design_system linear-app

  node inspo_cli.js raw <toolName> '<jsonArguments>'
      Call any tool with raw JSON arguments.
      Example: node inspo_cli.js raw recommend '{"brief":"minimal portfolio"}'
`);
    return;
  }

  try {
    if (command === 'list') {
      const tools = await listTools();
      console.log(`Found ${tools.length} Inspo tools:`);
      tools.forEach(t => {
        console.log(`\n• ${t.name}:`);
        console.log(`  ${t.description}`);
      });
      return;
    }

    let toolName = command;
    let toolArgs = {};

    if (command === 'recommend') {
      toolArgs = { brief: rest[0] || 'modern clean web application' };
      if (rest[1]) toolArgs.macrostructure = rest[1];
    } else if (command === 'find_components') {
      toolArgs = { type: rest[0] || 'hero' };
      if (rest[1]) toolArgs.style = rest[1];
    } else if (command === 'find_reference_components') {
      toolArgs = rest[0] ? { type: rest[0] } : {};
    } else if (command === 'get_reference_jsx') {
      if (!rest[0] || !rest[1]) {
        console.error('Error: get_reference_jsx requires <type> and <id>. Example: get_reference_jsx hero documentary');
        process.exit(1);
      }
      toolArgs = { type: rest[0], id: rest[1] };
    } else if (command === 'find_by_color') {
      toolArgs = { color: rest[0] || '#4F46E5' };
    } else if (command === 'get_design_system') {
      toolArgs = { slug: rest[0] || 'linear-app' };
    } else if (command === 'raw') {
      toolName = rest[0];
      try {
        toolArgs = rest[1] ? JSON.parse(rest[1]) : {};
      } catch (e) {
        console.error('Invalid JSON for raw tool arguments:', rest[1]);
        process.exit(1);
      }
    } else {
      // General tool call: try parsing first arg as JSON if exists
      if (rest[0] && rest[0].startsWith('{')) {
        toolArgs = JSON.parse(rest.join(' '));
      } else if (rest[0]) {
        toolArgs = { query: rest.join(' ') };
      }
    }

    const output = await callMcp(toolName, toolArgs);
    console.log(output);
  } catch (err) {
    console.error(`Error executing ${command}:`, err.message);
    process.exit(1);
  }
}

main();

# Godot Vercel Deploy Action 🎮🚀

GitHub Action to build and deploy Godot HTML5 games to Vercel with automatic preview deployments.

## Features ✨

- 🎮 Automatic Godot Web export
- 🚀 Deploy to Vercel (preview & production)
- ⚙️ Automatic configuration for Godot games
- 🔗 Return the URL of the deployed game

## Usage 📦

```yaml
name: Deploy Godot Game

on:
  pull_request:
    branches: [main, dev]
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Deploy to Vercel
        uses: Wizz0/godot-vercel-deploy@v1
        with:
          godot_version: '4.5.1'
          project_path: './'
          export_preset: 'Web'
          vercel_token: ${{ secrets.VERCEL_TOKEN }}
          vercel_org_id: ${{ secrets.VERCEL_ORG_ID }}
          vercel_project_id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel_project_name: 'my-godot-game'
          production: ${{ github.ref == 'refs/heads/main' }}
```

## Inputs

| Input | Required | Description | Default |
|----------|-------------|----------|--------------|
| `godot_version` | No | Godot Version | `4.5.1` |
| `project_path` | No | Path to Godot project | `.` |
| `export_preset` | No | Export preset name | `Web` |
| `export_path` | No | Export path (temp) | `./vercel-deploy` |
| `vercel_token` | Yes | Vercel API token | - |
| `vercel_org_id` | Yes | Vercel organization ID | - |
| `vercel_project_id` | Yes | Vercel project ID | - |
| `production` | No | Deploy in production | `false` |
| `vercel_project_name` | Yes* | Project name for URL generation | - |
| `custom_config` | No | Custom vercel.json | `""` |

*Requires if `production: false` and URL could not be extracted

## Outputs

| Output | Description |
|----------|----------|
| `url` | URL of the deployed game |

## Example: Pull Request Preview with Telegram Notification

```yaml
name: PR Preview

on:
  pull_request:
    branches: [ main, dev ]

jobs:
  preview:
    runs-on: ubuntu-latest
    
    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4
      
      - name: 🎮 Deploy Godot game to Vercel
        id: deploy
        uses: Wizz0/godot-vercel-deploy@v1
        with:
          godot_version: '4.5.1'
          project_path: './game'
          export_preset: 'Web'
          vercel_token: ${{ secrets.VERCEL_TOKEN }}
          vercel_org_id: ${{ secrets.VERCEL_ORG_ID }}
          vercel_project_id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel_project_name: 'my-godot-game'
      
      - name: 📝 Get PR info
        id: pr-info
        run: |
          echo "title=${{ github.event.pull_request.title }}" >> $GITHUB_OUTPUT
          echo "number=${{ github.event.pull_request.number }}" >> $GITHUB_OUTPUT
          echo "author=${{ github.event.pull_request.user.login }}" >> $GITHUB_OUTPUT
      
      - name: 📱 Send Telegram notification
        uses: appleboy/telegram-action@master
        with:
          to: ${{ secrets.TELEGRAM_CHAT_ID }}
          token: ${{ secrets.TELEGRAM_BOT_TOKEN }}
          message: |
            🔍 *New Pull Request Ready for Review!*
            
            *PR #${{ steps.pr-info.outputs.number }}:* ${{ steps.pr-info.outputs.title }}
            
            *Author:* @${{ steps.pr-info.outputs.author }}
            
            *🎮 Test the game here:*  
            ${{ steps.deploy.outputs.url }}
            
            *🔗 GitHub PR Link:*  
            https://github.com/${{ github.repository }}/pull/${{ github.event.pull_request.number }}
            
            _Please review the code and test the gameplay!_
          format: markdown
```

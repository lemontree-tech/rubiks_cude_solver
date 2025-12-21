# GitHub Pages Setup Guide

This repository includes a simple GitHub Pages website. Follow these steps to enable it:

## Quick Setup

1. **Go to your repository settings**:
   - Navigate to: `https://github.com/lemontree-tech/rubiks_cude_solver/settings/pages`

2. **Configure GitHub Pages**:
   - **Source**: Select `Deploy from a branch`
   - **Branch**: Select `main` (or `master`)
   - **Folder**: Select `/docs`
   - Click **Save**

3. **Wait for deployment**:
   - GitHub will build and deploy your site
   - Usually takes 1-2 minutes
   - Your site will be available at: `https://lemontree-tech.github.io/rubiks_cude_solver/`

## What's Included

- **`docs/index.html`**: Main landing page with app information
- **`README.md`**: Project documentation (also visible on GitHub)
- **`PRIVACY.md`**: Privacy policy
- **`LICENSE`**: MIT License

## Customization

You can customize the website by editing:
- `docs/index.html` - Main page content and styling
- `README.md` - Project documentation
- `PRIVACY.md` - Privacy policy details

## Notes

- The `.nojekyll` file in `docs/` ensures GitHub Pages serves the HTML as-is
- The website will automatically update when you push changes to the `docs/` folder
- You can use a custom domain by adding a `CNAME` file in the `docs/` folder

## Troubleshooting

If the site doesn't appear:
1. Check that GitHub Pages is enabled in repository settings
2. Verify the `/docs` folder contains `index.html`
3. Wait a few minutes for GitHub to build the site
4. Check the "Actions" tab for any build errors


# GitHub Pages Setup Guide

## Quick Start - Deploy Landing Page in 2 Minutes

Your professional landing page is ready! Follow these steps to make it live:

### Step 1: Push to GitHub

```bash
git push origin main
```

### Step 2: Enable GitHub Pages

1. Go to your repository on GitHub: https://github.com/RajeshKumar11/eye_care_app
2. Click **Settings** (top navigation)
3. Click **Pages** (left sidebar)
4. Under "Build and deployment":
   - **Source**: Deploy from a branch
   - **Branch**: `main`
   - **Folder**: `/docs/landing-page` or `/docs` (select the dropdown)
   - Click **Save**

### Step 3: Wait for Deployment (1-2 minutes)

GitHub will build and deploy your site automatically.

### Step 4: Access Your Site

Your landing page will be live at:
```
https://rajeshkumar11.github.io/eye_care_app/
```

Or if deploying from `/docs`:
```
https://rajeshkumar11.github.io/eye_care_app/landing-page/
```

## Verify Deployment

1. Check deployment status:
   - Go to repository → Actions tab
   - Look for "pages build and deployment" workflow
   - Green checkmark = successful

2. Visit your live site:
   - Click the link in Pages settings
   - Or visit the URL directly

## Post-Deployment Tasks

### 1. Add Images (High Priority)

The landing page references these images. Add them to `docs/landing-page/images/`:

```
images/
├── app-screenshot.png      # 300x600px - Phone mockup
├── og-image.png           # 1200x630px - Social sharing
├── twitter-card.png       # 1200x675px - Twitter shares
├── favicon-32x32.png      # 32x32px - Browser icon
├── favicon-16x16.png      # 16x16px - Browser icon
└── apple-touch-icon.png   # 180x180px - iOS icon
```

**Quick solution**: The page works without images (shows placeholders), but add them for professionalism.

**Generate icons easily**:
- Screenshots: Capture from actual app
- Social images: Use Canva (free)
- Favicons: https://realfavicongenerator.net/

### 2. Set Up Google Analytics (Optional)

1. Create GA4 property: https://analytics.google.com
2. Get Measurement ID: `G-XXXXXXXXXX`
3. Edit `docs/landing-page/index.html`
4. Uncomment lines 76-83
5. Replace `G-XXXXXXXXXX` with your ID
6. Commit and push

### 3. Submit to Search Engines

**Google Search Console:**
1. Go to https://search.google.com/search-console
2. Add property: `https://rajeshkumar11.github.io/eye_care_app/`
3. Verify ownership (HTML tag method)
4. Submit sitemap: `https://rajeshkumar11.github.io/eye_care_app/sitemap.xml`

**Bing Webmaster Tools:**
1. Go to https://www.bing.com/webmasters
2. Add & verify site
3. Submit sitemap

### 4. Update Repository Settings

Add repository metadata:
1. Go to repository main page
2. Click ⚙️ (gear icon) next to "About"
3. Add:
   - **Description**: "Free open-source eye care app with blink reminders, 20-20-20 rule, and guided exercises"
   - **Website**: `https://rajeshkumar11.github.io/eye_care_app/`
   - **Topics**: `eye-care`, `flutter`, `android`, `ios`, `health`, `open-source`, `eye-strain`, `blink-reminder`, `20-20-20-rule`
4. Check ✅ "Releases", "Packages", "Environments"

## Customization

### Change Colors

Edit `docs/landing-page/css/style.css` (lines 3-14):

```css
:root {
    --primary-color: #2196F3;    /* Main brand color */
    --secondary-color: #4CAF50;   /* Accent color */
    --accent-color: #FF5722;      /* Highlights */
}
```

### Update Content

Edit `docs/landing-page/index.html`:

- **Line 8**: Page title
- **Line 10**: Meta description
- **Line 11**: Keywords
- **Lines 101-150**: Hero section
- **Lines 212-280**: Features

### Test Locally

Before pushing changes:

```bash
cd docs/landing-page
python -m http.server 8000
# Visit: http://localhost:8000
```

## Custom Domain (Optional)

### Using Custom Domain

1. Buy domain (e.g., eyecareapp.com)
2. Create `CNAME` file in `docs/landing-page/`:
   ```
   eyecareapp.com
   ```
3. Configure DNS:
   - Add CNAME record: `www` → `rajeshkumar11.github.io`
   - Add A records for apex domain:
     ```
     185.199.108.153
     185.199.109.153
     185.199.110.153
     185.199.111.153
     ```
4. GitHub Settings → Pages → Custom domain: `eyecareapp.com`
5. Enable "Enforce HTTPS"

## Monitoring & Optimization

### Check SEO Score

- **Google PageSpeed Insights**: https://pagespeed.web.dev/
  - Paste your URL
  - Aim for 90+ score

- **GTmetrix**: https://gtmetrix.com/
  - Analyze performance
  - Check recommendations

### Monitor Traffic

1. **GitHub Insights**:
   - Repository → Insights → Traffic
   - View views, clones, referrers

2. **Google Analytics** (if configured):
   - Real-time visitors
   - Page views
   - User demographics

### SEO Checklist

- [x] Sitemap submitted to Google
- [x] Sitemap submitted to Bing
- [ ] Google Analytics configured
- [ ] Images added and optimized
- [ ] Social media sharing tested
- [ ] Mobile-friendly test passed
- [ ] Page speed optimized
- [ ] Structured data validated

## Troubleshooting

### Site Not Loading

**Problem**: 404 error after deployment

**Solutions**:
1. Check Pages settings → Folder selection
2. Ensure `index.html` exists in selected folder
3. Wait 2-3 minutes for propagation
4. Clear browser cache (Ctrl+F5)

### Images Not Showing

**Problem**: Broken image links

**Solutions**:
1. Verify images are in `docs/landing-page/images/`
2. Check file names match exactly (case-sensitive)
3. Push images to GitHub
4. Wait for deployment

### Custom Domain Not Working

**Problem**: DNS not resolving

**Solutions**:
1. Verify DNS records (use https://dnschecker.org/)
2. Wait 24-48 hours for DNS propagation
3. Ensure CNAME file is in root of deployed folder
4. Check "Enforce HTTPS" is enabled

## Promotion Strategy

### Immediate Actions (Week 1)

1. **Social Media**:
   - Tweet with hashtags: #FlutterDev #EyeCare #OpenSource
   - Post on LinkedIn
   - Share in Flutter communities

2. **Reddit**:
   - r/FlutterDev (Show & Tell Saturday)
   - r/opensource
   - r/SideProject
   - r/Health

3. **Dev Communities**:
   - Dev.to article
   - Hashnode blog post
   - Medium article

### Ongoing (Monthly)

1. **Content Marketing**:
   - Blog about eye health for developers
   - Create YouTube demo video
   - Write case studies

2. **Community Engagement**:
   - Answer questions on StackOverflow
   - Participate in Flutter forums
   - Contribute to related projects

3. **SEO Improvements**:
   - Build quality backlinks
   - Update content regularly
   - Monitor search rankings

## Metrics to Track

### Traffic Goals

| Timeframe | Page Views | Unique Visitors | GitHub Stars |
|-----------|-----------|----------------|--------------|
| Week 1 | 100+ | 50+ | 10+ |
| Month 1 | 1,000+ | 500+ | 50+ |
| Month 3 | 5,000+ | 2,000+ | 200+ |
| Month 6 | 10,000+ | 5,000+ | 500+ |

### Conversion Goals

- Click-through to GitHub: >30%
- Download clicks: >15%
- Star rate: >5% of visitors

## Advanced Features

### Add Blog (Future)

Use Jekyll or create `blog/` directory:
```
docs/
├── landing-page/
└── blog/
    ├── index.html
    └── posts/
```

### Add Documentation Site

Use Docsify or VuePress:
```bash
npm i -g docsify-cli
docsify init ./docs/documentation
```

### Progressive Web App

Add `manifest.json` and service worker for offline support.

## Resources

- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [SEO Best Practices](https://developers.google.com/search/docs)
- [Web Performance](https://web.dev/performance/)
- [Accessibility](https://www.w3.org/WAI/WCAG21/quickref/)

## Support

Questions about deployment?
- GitHub Discussions: https://github.com/RajeshKumar11/eye_care_app/discussions
- Email: kakumanurajeshkumar@gmail.com

---

**Pro Tip**: Star the repository on GitHub to boost credibility! ⭐

**Last Updated**: 2026-01-16

# Installing SmartResume on iPhone

## Steps to Add to Home Screen

1. **Open Safari** on your iPhone (must be Safari, not Chrome or other browsers)

2. **Navigate to** your SmartResume URL (e.g., https://your-domain.com)

3. **Tap the Share button** (the square with an arrow pointing up) at the bottom of the screen

4. **Scroll down and tap "Add to Home Screen"**

5. **Customize the name** if desired (default is "SmartResume")

6. **Tap "Add"** in the top right corner

7. **Find the SmartResume icon** on your home screen - it now works like a native app!

## Features When Installed

- **Full Screen Mode**: Runs without Safari's browser UI
- **Home Screen Icon**: Quick access like any other app
- **Offline Support**: Service worker caches key resources
- **Status Bar**: Matches app theme (dark mode)
- **Fast Loading**: Cached assets load instantly

## Requirements

- iOS 11.3 or later
- Safari browser (for installation)
- Active internet connection (for first load)

## Troubleshooting

**Icon doesn't appear:**
- Make sure you're using Safari (not Chrome or Firefox)
- Check that you have storage space on your device
- Try closing Safari and reopening the website

**App won't open:**
- Delete the icon and reinstall
- Clear Safari cache: Settings > Safari > Clear History and Website Data
- Ensure you're connected to the internet

**Dark mode not working:**
- Check your system settings don't override app themes
- Update to latest iOS version

## Deployment Checklist for Production

- [ ] Deploy to HTTPS domain (required for PWA)
- [ ] Update manifest.json `start_url` with production URL
- [ ] Test on actual iPhone device
- [ ] Verify all icons display correctly
- [ ] Check offline functionality
- [ ] Test "Add to Home Screen" flow
- [ ] Verify push notifications (if implementing)

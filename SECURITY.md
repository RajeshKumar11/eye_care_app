# Security Policy

## Reporting a Vulnerability

The Eye Care App team takes security issues seriously. We appreciate your efforts to responsibly disclose your findings.

### How to Report

If you discover a security vulnerability, please follow these steps:

1. **DO NOT** open a public GitHub issue
2. Email the details to: **kakumanurajeshkumar@gmail.com**
3. Include the following information:
   - Description of the vulnerability
   - Steps to reproduce the issue
   - Potential impact
   - Suggested fix (if any)
   - Your name/handle for acknowledgment (optional)

### What to Expect

- **Acknowledgment**: We will acknowledge receipt of your report within 48 hours
- **Initial Assessment**: We will provide an initial assessment within 5 business days
- **Updates**: We will keep you informed of our progress
- **Resolution**: We aim to resolve critical issues within 30 days
- **Credit**: We will credit you in the fix announcement (if desired)

### Security Update Process

1. Vulnerability is reported and confirmed
2. A fix is developed and tested
3. A security patch is released
4. Security advisory is published
5. Reporter is credited (if desired)

## Supported Versions

We provide security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

We recommend always using the latest version of Eye Care App.

## Security Best Practices

### For Users

1. **Download from Official Sources**
   - Only download from official GitHub releases
   - Verify checksums when available
   - Avoid third-party app stores

2. **Permissions**
   - Review and understand requested permissions
   - Only grant necessary permissions
   - Regularly review app permissions in device settings

3. **Keep Updated**
   - Install updates promptly
   - Enable automatic updates if available
   - Check for updates regularly

4. **Data Privacy**
   - Eye Care App does not collect personal data
   - All settings are stored locally on your device
   - No data is transmitted to external servers

### For Developers

1. **Code Review**
   - All code changes require review
   - Security-sensitive changes require additional scrutiny
   - Follow secure coding guidelines

2. **Dependencies**
   - Regularly update dependencies
   - Monitor for known vulnerabilities
   - Use only necessary dependencies

3. **Testing**
   - Include security testing in CI/CD
   - Test permission handling
   - Validate input/output

## Known Security Considerations

### Android Permissions

The app requests the following permissions:

- **SYSTEM_ALERT_WINDOW**: Required for overlay reminders
  - Risk: Medium - Can draw over other apps
  - Mitigation: User must explicitly grant in system settings
  - Usage: Only for eye care reminders, not intrusive ads

- **POST_NOTIFICATIONS**: For reminder notifications
  - Risk: Low - Standard notification access
  - Mitigation: User can disable in app settings

- **FOREGROUND_SERVICE**: Background operation
  - Risk: Low - Allows app to run in background
  - Mitigation: Visible notification shows when active

- **WAKE_LOCK**: Keep device awake during exercises
  - Risk: Low - Can prevent device sleep
  - Mitigation: Only used during active exercises

- **SCHEDULE_EXACT_ALARM**: Precise reminder timing
  - Risk: Low - Schedule exact alarms
  - Mitigation: Used only for health reminders

### Privacy Guarantees

Eye Care App is designed with privacy in mind:

- **No Analytics**: We don't collect usage statistics
- **No Tracking**: We don't track your behavior
- **No Network Requests**: The app doesn't make external API calls
- **Local Storage Only**: All data stays on your device
- **No Third-Party Services**: No external SDKs or services
- **Open Source**: Code is publicly auditable

### Data Storage

- Settings stored in device local storage
- No cloud synchronization
- No data transmission
- Data deleted when app is uninstalled

## Security Features

### Current Implementation

1. **Minimal Permissions**: Request only essential permissions
2. **Runtime Permissions**: Request permissions when needed
3. **Permission Explanations**: Clear explanations before requests
4. **Graceful Degradation**: App functions without optional permissions
5. **Local-First**: All processing happens on device
6. **No External Dependencies**: No tracking or analytics SDKs

### Planned Improvements

- [ ] Add app signing verification
- [ ] Implement code obfuscation for releases
- [ ] Add integrity checks
- [ ] Enhanced permission management UI

## Compliance

Eye Care App complies with:

- **GDPR**: No personal data collection
- **CCPA**: No data sale or sharing
- **COPPA**: Safe for all ages
- **Mobile App Privacy**: Transparent about permissions

## Security Audit History

| Date | Auditor | Result | Notes |
|------|---------|--------|-------|
| 2026-01-16 | Internal | Pass | Initial security review |

## Disclosure Policy

- We follow responsible disclosure principles
- Security issues will be fixed before public disclosure
- We will credit security researchers (with permission)
- Critical vulnerabilities will be disclosed after fixes are deployed

## Bug Bounty Program

Currently, we do not have a formal bug bounty program. However, we deeply appreciate security researchers who report vulnerabilities responsibly and will:

- Acknowledge your contribution
- Credit you in our security advisories (if desired)
- Provide updates on the fix progress
- Consider featuring you in our contributors list

## Resources

- Report Security Issues: kakumanurajeshkumar@gmail.com
- General Issues: [GitHub Issues](https://github.com/RajeshKumar11/eye_care_app/issues)
- Discussions: [GitHub Discussions](https://github.com/RajeshKumar11/eye_care_app/discussions)

## Contact

For security concerns, contact:
- **Email**: kakumanurajeshkumar@gmail.com
- **Response Time**: Within 48 hours
- **PGP Key**: Available upon request

## Additional Information

### Secure Development Lifecycle

1. **Design**: Security considerations in feature design
2. **Development**: Secure coding practices
3. **Review**: Mandatory code review process
4. **Testing**: Security testing before release
5. **Deployment**: Signed releases only
6. **Monitoring**: Track reported issues
7. **Response**: Quick security patch deployment

### Third-Party Dependencies

We maintain a minimal dependency footprint:
- All dependencies are reviewed for security
- Regular updates for security patches
- Automated vulnerability scanning
- Dependencies listed in pubspec.yaml

---

**Last Updated**: January 16, 2026

Thank you for helping keep Eye Care App secure!

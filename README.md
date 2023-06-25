# Overview

Proof of Concept application to use Google Sheets as a database. This
application allows users to keep a virtual tab for their drink purchases.

For demonstration purposes, the app starts with using ActiveRecord and sqlite.
You can use a button on the homepage to toggle between ActiveRecord and GoogleSheets.

### ActiveRecord view
<img width="1680" alt="image" src="https://github.com/joseph1wan/westgate-tab/assets/25408114/030b5f0b-5fb1-49eb-9420-f9cba76ade1c">

### Google Sheets view
<img width="1680" alt="image" src="https://github.com/joseph1wan/westgate-tab/assets/25408114/0a951baa-7701-4392-be59-20d69ba071e3">

## Tech

- Stack: Ruby on Rails (sprinkled with Turbo)
- CSS: Tailwind CSS
- External APIs: Google Sheets API

# Set up

## Environment Variables

- `GOOGLE_APPLICATION_CREDENTIALS`: Path to Google service account key JSON file.
- `SPREADSHEET_ID`: The Sheets ID to use for the tab in production.
- `TEST_SPREADSHEET_ID`: The Sheets ID to use for the tab in tests (for VCR) and development

**Note:** This project uses `dotenv` in testing and development, so `.env` is an option.

## Google Authorization

1. Enable the **Google Sheets API** in your Google Cloud project.
2. Create a service account for this app.
3. Generate and download key to `./auth.json`.
4. Set the `GOOGLE_APPLICATION_CREDENTIALS` environment variable to `"./auth.json"`.

# Development

In separate sessions, run the Rails server and asset server (for autoloading
Tailwind CSS changes):

```bash
bin/rails s
```

```bash
bin/dev
```

# Testing
Tests in `client_spec` use VCR to record and playback API calls. Before running
the test suite for the first time, delete the `spec/cassettes` directory.
Alternatively, you pass in `VCR=all` to force VCR to re-record interactions.

Run `bin/rspec` to run tests.

Run `VCR=all bin/rspec` to run tests and re-record interactions.

# References
Tailwind UI components from [HyperUI](https://www.hyperui.dev)
Tailwind Icons from [heroicons](https://heroicons.com)

# Server Driven User Interface (SDUI)

<img height="600" alt="2d8e944e3321152752140369be02b273d3e5d6c6" src="https://github.com/user-attachments/assets/fde45898-df7a-49bc-a2ee-185b96891a54" />

## Background

This project was submitted as my third-year minor project. As the name suggests, Server Driven UI allows you to programmatically control the UI of your application. It is generally used in mobile applications, where the update and review cycle is long relative to the current CI/CD approach.

Other than the obvious use cases like fixing typos that crept into the UI or swapping elements for festive themes, SDUI offers granularity down to the individual user level. This allows several powerful capabilities: personalising screens for each user programmatically, surfacing their most relevant features front and center, enabling better A/B testing, and collecting more granular usability data per feature to increase retention and manage churn.

SDUI is already used in production by companies like Amazon, Netflix, Airbnb, Lyft and Spotify. This project is an attempt at a clean and modular implementation.

## Writeup

### Features

1. Cross Platform Renderer - Supports both Android and iOS

2. Visual editor — WYSIWYG editor to design and push UI changes without touching the schema directly, making it accessible to non engineers.

3. Edge delivery — UI configs are served from edge nodes, cutting latency for geographically distributed users.

4. Schema validation — Visual editor and server ensures malformed responses are caught before they reach the renderer.

5. Multi-file, multi-language support — The architecture supports splitting UI definitions across multiple files and serving them in different languages, enabling localization at scale.
### Architecture

<img height="400" alt="23383210fd785fff74fa1ddde369cbe5d2a02261" src="https://github.com/user-attachments/assets/aa6d0848-e22f-4906-b015-12f5ed3faebe" />

- **Mobile Rendering Engine** - Converts JSON-based UI specs into rendered components via a custom widget factory, with a parsing layer to handle multiple schema versions. Maintains a local cache for offline functionality.

- **Server** - Hosts UI configurations segmented by user groups, regions, or experiment cohorts. UI configurations (layout, content, styles, behavior) are stored as JSON files on the server and CDN.

- **Web Interface** - A cloud-based WYSIWYG editor to create, preview, and deploy UI changes in real-time. Realtime preview to validate changes before going live.

- **Analytics** - User interaction and engagement data is captured client side and is flushed after 20 events to the server for collection.

### Tech Stack

- Flutter - Allows us to deploy the same client renderer on iOS and Android.

- FastAPI + Postgres as backend server, NextJs for frontend

- AWS S3 and Cloudflare CDN (any S3 compatible storage and CDN should work)
## Demo
[![▶ Watch Demo](https://img.shields.io/badge/▶_Watch_Demo-YouTube-red)](https://youtu.be/d-snSjMvyTM)

## Further Improvements

1. **Binary serialization** — Protocols like Protocol Buffers, Cap'n Proto, or FlatBuffers could replace JSON to reduce payload size and improve speed while also (in some cases) reducing deserializaion overhead on client side.

2. **Real-time analytics + ML** — Coupling usage analytics with ML models could enable super personalised experiences. For example, an Indian user in the US could be served a festive offer tied to a holiday not celebrated there, improving conversion rates.

3. **QUIC / HTTP3** — Would reduce latency and improve load times, especially on unreliable mobile connections since its udp based.

4. **Granular telemetry** — Per feature usage and metric collection to understand how users interact with each UI component and their sequence, to make it friction less.

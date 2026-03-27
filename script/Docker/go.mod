pake https://chatgpt.com --name "Apple Intelligence" --title "Apple Intelligence" --icon "$HOME/Downloads/app
le-intelligence.png" --install

I also checked the installed 3.11.0 package locally.

The zoom fix is present in this version:

- on macOS, zoom still uses html.style.zoom = zoom
- then it calls window.dispatchEvent(new Event("resize"))

So this does not look like the fix is missing from 3.11.0.

However, in my test, Cmd + + still causes parts of the ChatGPT UI to disappear after zooming in.

This makes me think the current resize dispatch is not sufficient for the latest ChatGPT.com layout/rendering
behavior on macOS WebKit.

Could you check whether an extra repaint/reflow step is needed after CSS zoom, or whether this case should use
native webview zoom instead of html.style.zoom?

<img width="1440" height="932" alt="Image" src="https://github.com/user-attachments/assets/d3c657d1-69fc-483c-ac73-5db1128cf1db" />

I’m also wondering whether this could be related to my local macOS display settings. I’m using the “Larger Text” display scaling option on my Mac, and that may be affecting layout calculations in the WebKit-based webview, which could be contributing to the issue as well.

<img width="461" height="717" alt="Image" src="https://github.com/user-attachments/assets/0b12efd9-c2d7-46fe-94b5-b9901520ea56" />

# NODE.js

Learn how to run a model on Replicate using Node.js.

This guide includes a quickstart to scaffold a new project with a single command in your terminal, followed by a step-by-step tutorial for setting up a project from scratch. By the end, you’ll have a working Node.js project that can run any model on Replicate.

[](#prerequisites)Prerequisites
-------------------------------

**Node.js 16 or greater:** The simplest way to install Node.js is using the installer at [nodejs.org](https://nodejs.org/).

[](#-quickstart-scaffold-a-project-with-a-one-liner)Quickstart: Scaffold a project with a one-liner
---------------------------------------------------------------------------------------------------

To get up and running as quickly as possible, you can use [create-replicate](https://github.com/replicate/create-replicate), an npm package that creates a project directory for you, writes some starter code, installs the dependencies, and runs the code.

# Run the following command to scaffold a new project:

``` shell
npx create-replicate
```

``
#That’s it. You should now have a working Node.js project that generates images with the [FLUX.1 \[schnell\]](https://replicate.com/black-forest-labs/flux-schnell) model using Replicate’s API.

If you want to use a different model than FLUX.1 \[schnell\], specify it when creating your project:
``

```shell
npx create-replicate --model black-forest-labs/flux-schnell
```
 
 ``
To learn more about scaffolding new Node.js projects, check out the [create-replicate documentation](https://github.com/replicate/create-replicate).

[](#-slowstart-set-up-a-project-from-scratch)Slowstart: Set up a project from scratch
-------------------------------------------------------------------------------------

If you prefer to manually set up your Node.js project step by step, follow the instructions below.

### [](#step-1-authenticate)Step 1: Authenticate

Authenticate by setting your Replicate API token in an environment variable:

```shell
export REPLICATE_API_TOKEN=r8_******
```

### [](#step-2-create-a-new-nodejs-project)Step 2: Create a new Node.js project

```shell
# create the directory
mkdir my-replicate-app
cd my-replicate-app
# set up package.json
npm init -y
npm pkg set type=module
```

### [](#step-3-install-the-replicate-javascript-client)Step 3: Install the Replicate JavaScript client

Use npm to install the [Replicate JavaScript client](https://github.com/replicate/replicate-javascript):

```shell
npm install replicate
```

### [](#step-4-write-some-code)Step 4: Write some code

Create a file called `index.js` and add the following code:

``` javascript
import Replicate from "replicate";
const replicate = new Replicate();
console.log("Running the model...");
const [output] = await replicate.run(
  "black-forest-labs/flux-schnell",
  {
    input: {
      prompt: "An astronaut riding a rainbow unicorn, cinematic, dramatic",
    },
  }
);
// Save the generated image
import { writeFile } from "node:fs/promises";
await writeFile("./output.png", output);
console.log("Image saved as output.png");
```

### [](#step-5-run-your-code)Step 5: Run your code

Next, run your code from your terminal:

```shell
node index.js
```

You should see output indicating the model is running and the image has been saved:

```shell
Running the model...
Image saved as output.png
```

[](#next-steps)Next steps
-------------------------

Now you’re up and running on Replicate with Node.js.

In this guide you used the FLUX.1 \[schnell\] image generation model, but you can adapt the code to run any model on Replicate. Try [editing existing images with text prompts using FLUX.1 Kontext Pro](https://replicate.com/black-forest-labs/flux-kontext-pro?input=nodejs), or [writing AI-generated code using Claude Sonnet 4](https://replicate.com/anthropic/claude-4-sonnet?input=nodejs). There are [thousands of public models](https://replicate.com/explore) on Replicate, and you can run any of them using the project you just created.

[](#further-reading)Further reading
-----------------------------------

*   [Build a website with Next.js](/docs/get-started/nextjs) and deploy it to Vercel
*   [Replicate JavaScript client reference](https://github.com/replicate/replicate-javascript#readme)
*   [setup-replicate documentation](https://github.com/replicate/setup-replicate#readme)
*   [HTTP API reference](https://replicate.com/docs/reference/http)

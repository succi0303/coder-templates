---
name: Terraform Template
description: Use this template to create a terraform orkspace on Coder.
tags: [docker, terraform]
---

# Coder Terraform Template

A Terraform template for [Coder](https://coder.com/).

## Coder Setup

Follow these steps to configure accessing your workspaces locally on any machine.

### Linux/MacOS

1. Open a terminal and run

   ```bash
   curl -L https://coder.com/install.sh | sh
   ```

### Windows

1. Open a `powershell` window and run

   ```powershell
   winget install Coder.Coder
   ```

## Usage

1. Clone this repository

   ```bash
   git clone https://github.com/succi0303/coder-templates
   cd coder-templates/terraform
   ```

2. Login to coder

   ```bash
   coder login CODER_URL
   ```

3. Create a template

   ```bash
   coder templates create terraform
   ```

4. Create a workspace

   Go to `https://CODER_URL/workspaces` and click on **Create Workspace** and select **terraform** template.

> Note: Do not forget to change the `CODER_URL` to your coder deployment URL.

## Terraform versions

There are options to choose terraform versions.
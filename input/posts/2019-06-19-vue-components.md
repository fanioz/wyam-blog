---
Title: Vue Components
Tags: [Vue]
author: Johan Vergeer
---

> Components are Vue Instances

Let's start with a simple Vue application. This is the most basic application you could get. 

<?# Gist f18b4f9e9785496326c082b78c76ef23 File="simple-vue-app.js" /?>

# Global components

<?# Gist f18b4f9e9785496326c082b78c76ef23 File="separate-component.js" /?>

## Global component limitations

- Global variables cause problems because they can be hard to locate and it is easy to run into naming conflicts
- Global components use _String Templates_, which means all html has to be defined in a Javascript string
  - No syntax highligting
  - Lot of escaping the html
- CSS is not encapsulated, which makes us rely on global CSS styling
- Global components don't provide any build-time compilation support. This means preprocessing is impossible.

Global components are fine for small applications and prototyping, but for larger applications we should use Single-file comopents.

# Simgle-file components

> A single-file component is a file with a _.vue_ extension.

It typically includes three secions: template, script and style

<?# Gist f18b4f9e9785496326c082b78c76ef23 File="vue-component-sections.js" /?>

Typically single-file components are used in a Vue application.
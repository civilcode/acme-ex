# BEM

### BEM - Blocks, Elements and Modifier

Summarized from the [Bem page](http://getbem.com/introduction).

## Definition
- **Block** : Standalone entity that is meaningful on its own.

    _Examples:_:
    `header, container, menu, checkbox, input`

- **Element** : A part of a block that has no standalone meaning and is semantically tied to its block.

    _Examples:_
    `menu item, list item, checkbox caption, header title`

- **Modifier** : A flag on a block or element. Use them to change appearance or behavior.

    _Examples:_:
    `disabled, highlighted, checked, fixed, size big, color yellow`
    
## CSS usage in a nutshell
```css
.block { .. }

.block__element { .. }

/* A modifier can be applied on a block or an element */
.block--modifier { .. }
.block--long-modifier { .. }

.block__element--modifier { .. }
.block__element--long-modifier { .. }
```

The full naming convention is fully described [here](http://getbem.com/naming/)

### Example

HTML:
```html
<button class="button">
	Normal button
</button>
<button class="button button--state-success">
	Success button
</button>
<button class="button button--state-danger">
	Danger button
</button>
```

CSS:

```css
.button {
	display: inline-block;
	border-radius: 3px;
	padding: 7px 12px;
	border: 1px solid #D5D5D5;
	background-image: linear-gradient(#EEE, #DDD);
	font: 700 13px/18px Helvetica, arial;
}
.button--state-success {
	color: #FFF;
	background: #569E3D linear-gradient(#79D858, #569E3D) repeat-x;
	border-color: #4A993E;
}
.button--state-danger {
	color: #900;
}
```

We can have a normal button for usual cases, and two more states for different ones. Because we style blocks by class selectors with BEM, we can implement them using any tags we want (button, a or even div). The naming rules tell us to use block--modifier-value syntax.


<hr />


# BEM Full Rules

## Naming Rules
- **Block** :

Block names may consist of Latin letters, digits, and dashes. To form a CSS class, add a short prefix for namespacing: `.block`

- **Element** : 

Element names may consist of Latin letters, digits, dashes and underscores. CSS class is formed as block name plus two underscores plus element name: `.block__elem`

- **Modifier** : 

Modifier names may consist of Latin letters, digits, dashes and underscores. CSS class is formed as block’s or element’s name plus two dashes: `.block--mod` or .`block__elem--mod` and `.block--color-black` with `.block--color-red`. Spaces in complicated modifiers are replaced by dash.

## HTML Rules
- **Block** :

    Any DOM node can be a block if it accepts a class name.

    ```html
    <div class="block">...</div>
    ```
- **Element** :

    Any DOM node within a block can be an element. Within a given block, all elements are semantically equal.

    ```html
    <div class="block">
    ...
    <span class="block__elem"></span>
    </div>
    ```
- **Modifier** :

    Modifier is an extra class name which you add to a block/element DOM node. Add modifier classes only to blocks/elements they modify, and keep the original class:

    Good

    ```html
    <div class="block block--mod">...</div>
        <div class="block block--size-big
            block--shadow-yes">...</div>
    ```

    Bad

    ```html
    <div class="block--mod">...</div>
    ```

## CSS Rules
- **Block** :

    - Use class name selector only
    - No tag name or ids
    - No dependency on other blocks/elements on a page

    ```css
    .block { color: #042; }
    ```

- **Element** :

    - Use class name selector only
    - No tag name or ids
    - No dependency on other blocks/elements on a page

    Good

    ```css
    .block__elem { color: #042; }
    ```

    Bad

    ```css
    .block .block__elem { color: #042; }
        div.block__elem { color: #042; }
    ```
- **Modifier** :

    Use modifier class name as selector:

    ```css
    .block--hidden { }
    ```

    To alter elements based on a block-level modifier:

    ```css
    .block--mod .block__elem { }
    ```

    Element modifier:

    ```css
    .block__elem--mod { }
    ```

## A more complete example

Suppose you have block form with modifiers theme: "xmas" and simple: true and with elements input and submit, and element submit with its own modifier disabled: true for not submitting form while it is not filled:

HTML

```html
<form class="form form--theme-xmas form--simple">
  <input class="form__input" type="text" />
  <input
    class="form__submit form__submit--disabled"
    type="submit" />
</form>
```

CSS

```css
.form { }
.form--theme-xmas { }
.form--simple { }
.form__input { }
.form__submit { }
.form__submit--disabled { }
```

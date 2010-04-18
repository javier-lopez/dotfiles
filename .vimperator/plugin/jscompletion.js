
function evalXPath(xpath, doc, namespace) {
    let res = doc.evaluate(xpath, doc,
        function getNamespace(prefix) {
            switch (prefix) {
            case "xhtml": return "http://www.w3.org/1999/xhtml";
            case "liberator": return NS.uri;
            case "ns": return namespace;
            default: return null;
            }
        },
        XPathResult.UNORDERED_NODE_ITERATOR_TYPE,
        null
    );
    res.__iterator__ = function () { let elem; while ((elem = this.iterateNext())) yield elem; };
    return res;
}

let escape = util.escapeString;
let NAMESPACES = [
    ["http://www.w3.org/1999/xhtml", "XHTML"],
    ["www.mozilla.org/keymaster/gatekeeper/there.is.only.xul", "XUL"],
];

function addCompleter(names, fn) {
    for (let [,name] in Iterator(Array.concat(names)))
	completion.javascriptCompleter.completers[name] = fn;
}

function elemToString(elem) {
    return "<" + [elem.localName].concat([a.name + "=" + a.value for (a in util.Array.iterator(elem.attributes))]).join(" ") + 
        (elem.firstChild ? "...</" + elem.localName + ">" : "/>")
}

addCompleter("eval", function (context, func, obj, args) {
    if (args.length > 1)
        return [];
    if (!context.cache.js)
    {
        context.cache.js = new completion.javascriptCompleter.constructor();
        context.cache.context = CompletionContext("");
    }
    let ctxt = context.cache.context;
    context.keys = { text: "text", description: "description" };
    ctxt.filter = context.filter;
    context.cache.js.complete(ctxt);
    context.advance(ctxt.offset);
    context.completions = ctxt.allItems.items;
});

addCompleter("getElementById", function (context, func, doc, args) {
    if (args.length > 1)
	return [];
    let key = args.pop()
    let iter = evalXPath("//*[@id and contains(@id," + escape(key, "'") + ")]", doc);
    return [[e.getAttribute("id"), elemToString(e)] for (e in iter)];
});

function addCompleterNS(names, fn) {
    let names = util.Array.flatten(Array.concat(names).map(function (n) [n, n + "NS"]));
    addCompleter(names, function checkNS(context, func, obj, args) {
        let isNS = /NS$/.test(args);
        if (isNS && args.length == 1)
            return NAMESPACES;
        let prefix = isNS ? "ns:" : "";
        return fn(context, func, obj, args, prefix, isNS && args.shift());
    });
}

addCompleterNS("getElementsByClassName", function (context, func, doc, args, prefix, namespace) {
    if (args.length > 1)
	return [];
    let iter = evalXPath("//@class", doc, namespace);
    return util.Array.uniq([e for (e in iter)]).map(function (class) [class, ""]);
});

addCompleterNS("getElementsByTagName", function (context, func, doc, args, prefix, namespace) {
    /* *Very* bad idea. */
    let iter = evalXPath("//" + prefix + "*", doc, namespace);
    return util.Array.uniq([e.localName.toLowerCase() for (e in iter)]).map(function (tag) [tag, ""]);
});

addCompleterNS("getElementsByClassName", function (context, func, doc, args, prefix, namespace) {
    let iter = evalXPath("//@" + prefix + "class", doc, namespace);
    return util.Array.uniq([e.value for (e in iter)]).map(function (class) [class, ""]);
});

addCompleterNS("getElementsByAttribute", function (context, func, doc, args, prefix, namespace) {
    switch (args.length) {
    case 1:
	let iter = evalXPath("//@" + prefix + "*", doc, namespace);
	return util.Array.uniq([e.name for (e in iter)]).map(function (attrib) [attrib, ""]);
    case 2:
	let attrib = args[0 + isNS];
	iter = evalXPath("//@" + prefix + attrib, doc, namespace);
	return util.Array.uniq([e.value for (e in iter)]).map(function (value) [value, ""]);
    }
});

addCompleterNS(["remove", "get", "set"].map(function (i) [i + "Attribute"]),
    function (context, func, node, args, prefix, namespace) {
        if (args.length > 1)
            return [];
        return [[a.name, a.value] for (a in util.Array.iterator(node.attributes)) if (!namespace || a.namespaceURI == namespace)];
    });


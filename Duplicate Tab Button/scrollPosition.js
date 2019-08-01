if (window.top === window) {
    document.addEventListener("DOMContentLoaded", function(event) {
        safari.extension.dispatchMessage("DOM content loaded");
    });

    safari.self.addEventListener("message", function(event) {
        let scrollPosition = event.message["scrollPosition"];

        document.body.scrollLeft = scrollPosition[0];
        document.body.scrollTop = scrollPosition[1];
    });

    window.addEventListener("scroll", throttle(function() {
        const scrollPosition = [window.scrollX, window.scrollY];

        safari.extension.dispatchMessage("updateScrollPosition",
                                         { "scrollPosition": scrollPosition });
        }, 250)
    );
}

function throttle(func, wait) {
    var timeout;

    return function() {
        var context = this, args = arguments;
        var delay = function() {
            timeout = null;
            func.apply(context, args);
        };

        clearTimeout(timeout);
        timeout = setTimeout(delay, wait);

        if (!timeout) {
            func.apply(context, args);
        }
    }
}

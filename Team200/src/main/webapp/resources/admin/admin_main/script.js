 function openTab(evt, tabName) {
            var i, tabpane, tablinks;
            tabpane = document.getElementsByClassName("tab-pane");
            for (i = 0; i < tabpane.length; i++) {
                tabpane[i].style.display = "none";
                tabpane[i].classList.remove("active");
            }
            tablinks = document.getElementsByClassName("tab-btn");
            for (i = 0; i < tablinks.length; i++) {
                tablinks[i].classList.remove("active");
            }
            document.getElementById(tabName).style.display = "block";
            document.getElementById(tabName).classList.add("active");
            evt.currentTarget.classList.add("active");
        }
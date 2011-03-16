/*
Dynamic Tabs 1.0.1
Copyright (c) 2005 Rob Allen (rob at akrabat dot com)

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

*/


function getChildElementsByClassName(parentElement, className)
{
	var i, childElements, pattern, result;
	result = new Array();
	pattern = new RegExp("\\b"+className+"\\b");


	childElements = parentElement.getElementsByTagName('*');
	for(i = 0; i < childElements.length; i++)
	{
		if(childElements[i].className.search(pattern) != -1)
		{
			result[result.length] = childElements[i];
		}
	}
	return result;
}


function BuildTabs(containerName)
{
	var i, tabContainer, tabContents, tabHeading, title, tabElement;
	var divElement, ulElement, liElement, tabLink, linkText;


	// assume that if document.getElementById exists, then this will work...
	if(! eval('document.getElementById') ) return;

	tabContainer = document.getElementById(containerName);
	if(tabContainer == null)
		return;

	tabContents = getChildElementsByClassName(tabContainer, 'tab-content');
	if(tabContents.length == 0)
		return;

	divElement = document.createElement("div");
	// X divElement.id = "tab-header-" + containerName;
  divElement.className = 'tab-header'
	ulElement = document.createElement("ul");
	// X ulElement.id = "tab-list-" + containerName;
  ulElement.className = 'tab-list'

	//tabContainer.insertBefore(divElement, tabContents[0]);
	tabContainer.insertBefore(divElement, tabContainer.firstChild);
	divElement.appendChild(ulElement);

	for(i = 0 ; i < tabContents.length; i++)
	{
		tabHeading = getChildElementsByClassName(tabContents[i], 'tab');
		title = tabHeading[0].childNodes[0].nodeValue;


		// create the tabs as an unsigned list
		liElement = document.createElement("li");
		tabLink = document.createElement("a");
		linkText = document.createTextNode(title);

		tabLink.className = "tab-item";
		liElement.className = "li-item li-unvisited";

		tabLink.setAttribute("href","javascript://");
		tabLink.setAttribute( "title", tabHeading[0].getAttribute("title"));
		tabLink.onclick = new Function ("ActivateTab('" + containerName + "', " + i + ")");


		ulElement.appendChild(liElement);
		liElement.appendChild(tabLink);
		tabLink.appendChild(linkText);

		// remove the H1
		tabContents[i].removeChild


		//alert(thisTab);

	}
}

function ActivateTab(containerName, activeTabIndex)
{
	var i, tabContainer, tabContents;

	tabContainer = document.getElementById(containerName);
	if(tabContainer == null)
		return;

	tabContents = getChildElementsByClassName(tabContainer, 'tab-content');
	if(tabContents.length > 0)
	{
		for(i = 0; i < tabContents.length; i++)
		{
			//tabContents[i].className = "tab-content";
			tabContents[i].style.display = "none";
		}

		tabContents[activeTabIndex].style.display = "block";

                if ($('fin_empotrado')) {
                    new Effect.ScrollTo('fin_empotrado');
                }

		// X tabList = document.getElementById('tab-list-' + containerName);
                tabList = document.getElementById(containerName + '-list');
		tabs = getChildElementsByClassName(tabContainer, 'tab-item');
		if(tabs.length > 0)
		{
			for(i = 0; i < tabs.length; i++)
			{
				tabs[i].className = "tab-item";
                                //Para que funcione con las clases de la caja
                                if (tabs[i].parentNode.className == "li-item li-unvisited")
                                {
                                    tabs[i].parentNode.className = "li-item li-unvisited";
                                } else {
                                    tabs[i].parentNode.className = "li-item";
                                }
			}

			tabs[activeTabIndex].className = "tab-item tab-active";
                        //Para que funcione con las clases de la caja
                        tabs[activeTabIndex].parentNode.className = "li-item li-active";
			tabs[activeTabIndex].blur();
		}
	}
}

function CambiaMenu(opcion) {
    li = opcion.parentNode; //li padre del a que hemos pulsado
    lis = li.parentNode.firstChild; //Recorremos todos los li y les vaciamos la clase
    while (lis != null) {
        //Guarrada, pendiente de hacer menú genérico nuestro
        if (lis.nodeType == 1 && lis.className != 'li-user' && lis.className != 'li-group' && lis.className != 'li-separator') {
          lis.className='';
          //lis.getElementsByTagName('ul')[0].style.display='none';
        }
        lis=lis.nextSibling;
    }
    li.className='li-active'; //ahora ponemos activo el correcto
    document.getElementById('aviso').innerHTML = '';
    document.getElementById('cuerpo').innerHTML = '<h1>'+opcion.innerHTML+'</h1>';
}

function CambiaSubMenu(opcion) {
    li = opcion.parentNode;
    a = li.parentNode.firstChild;
    while (a != null) {
        //Guarrada, pendiente de hacer menú genérico nuestro
        if (a.className != 'li-user') a.className='';
        a=a.nextSibling;
    }
    li.className='li-active';
}

BuildTabs('tab-container');
ActivateTab('tab-container', 0);
BuildTabs('tab-container-2');
ActivateTab('tab-container-2', 0);

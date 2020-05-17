"use strict";
/**
 * fonction d'initialisation ajax de la liste d'anime qui ira s'ajouter à la page myAnimeList.html
 * @author Quentin Servais HE201860
*/
function initListe(){
	var ourRequest = new XMLHttpRequest();
	ourRequest.open('GET', '/getAnimeList?token=' + getCookie("token"));
	ourRequest.onload = function (){
		var ourData = JSON.parse(ourRequest.responseText);
		if(ourData.length > 0){
			renderHTML(ourData);
		}
		else {
  		document.getElementById("liste").innerHTML = "";
}

	};
	ourRequest.send();
}

/**
 * fonction de rendu html
 * @author Quentin Servais

 * @param {array} data: contient un array d'objets
*/
function renderHTML(data){
	var box = document.getElementById("liste");
	var cols = Object.keys(data[0]);
	var titre = "<tr>";
	for(var i in cols){
		titre += "<th>" + cols[i] + "</th>"; //mise en place du Thead
  }
  titre += "</tr>";

	var liste = "";
	for(var i in data){
		liste += "<tr>"; //mise en place du Tbody
		liste += "<td>" + data[i].anime + "</td>";
		liste += "<td>" + data[i].note + "</td>";
		liste += "<td>" + data[i].genre + "</td>";
		liste += "</tr>"
	}

  var table = "<table>" + titre + liste + "</table>";
  box.innerHTML = table; //position du tableau dans le html
}
/**
 * fonction d'initialisation ajax pour préparer le formulaire de suppression
 * @author Quentin Servais
*/
function initSuppr(){
	var suppRequest = new XMLHttpRequest();
	suppRequest.open('GET', '/getTitre?token=' + getCookie("token"));
	suppRequest.onload = function (){
		var suppr = JSON.parse(suppRequest.responseText);
		addSelect(suppr);
	};
	suppRequest.send();
}
/**
 * fonction d'initialisation du formulaire de suppression
 * @author Quentin Servais

*/
function addField(){
    var container = document.getElementById("field");
  	container.classList.toggle('hidden');
		initSuppr();
}
/**
 * fonction d'initialisation ajax pour préparer le formulaire de suppression
 * @author Quentin Servais

 * @param {HTMLFormElement} form : le formaulaire
*/
function suppression(form){
	var supprime = new XMLHttpRequest();
	supprime.open('GET', '/remove?id=' + form.select.value +'&token=' + getCookie("token"));
	supprime.onload = function(){
		var del	= supprime.responseText;
		document.getElementById("resultat").innerHTML = del;
		initListe();
	};
	supprime.send();
	return false;
}
/**
 * fonction qui créé les options de la liste déroulante de suppression
 * @author Quentin Servais

 * @param {object} obj : objet de la requête
*/
function addSelect(obj){
	var container = document.getElementById("selectTitre");
	var strHTML = "";
	for(let i of obj){
		strHTML += `<option value="${i.id}">${i.anime}</option>`;
	}
	container.innerHTML = strHTML;
}

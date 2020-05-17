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
	renderHTML(ourData);
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

function initSuppr(){
var suppRequest = new XMLHttpRequest();
suppRequest.open('GET', '/getTitre?token=' + getCookie("token"));
suppRequest.onload = function (){
var suppr = JSON.parse(suppRequest.responseText);
addSelect(suppr);
};
suppRequest.send();
}

function addField(){
    var container = document.getElementById("field");
    container.innerHTML =     '<form onsubmit="suppression(this);"><label for="selectTitre">Anime à supprimer:</label><br><select id="selectTitre" name="select"></select><br><input type="submit" value="Submit"></form>';
		initSuppr();
}

function suppression(form){
	var supprime = new XMLHttpRequest();
	supprime.open('GET', '/remove?id=' + form.select +'&token=' + getCookie("token"));
	supprime.onload = function(){
	var del	= supprime.responseText;
	document.getElementById("field").innerHTML = del;
};
supprime.send();
}

function addSelect(obj){
	var container = document.getElementById("selectTitre");
	var strHTML = "";
	for(let i of obj){
		strHTML += `<option value="${i.id}">${i.anime}</option>`;
	}
	container.innerHTML = strHTML;
}

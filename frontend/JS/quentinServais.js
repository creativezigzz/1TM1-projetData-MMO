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

function addField(){
	var container = document.getElementById("field");
	container.innerHTML = 	'<form><label for="toRemove">Anime à supprimer:</label><br><input type="text" id="toRemove" name="toRemove"><br><input type="submit" value="Submit"></form>';
}
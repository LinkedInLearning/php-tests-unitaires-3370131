<?php

// Mauvais exemple
$a = calculateArea($width, $height);

// Bon exemple
$rectangleArea = calculateRectangleArea($rectangleWidth, $rectangleHeight);

// Mauvais exemple
function processUserRegistration($username, $email, $password, $address, $phoneNumber) {
    // Traitement complexe
    // ...
}

// Bon exemple
function registerUser($username, $email, $password) {
    // Traitement pour l'enregistrement d'un utilisateur
    // ...
}

// Mauvais exemple
if ($condition1) {
    if ($condition2) {
        if ($condition3) {
            // Traitement
        }
    }
}

// Bon exemple
if ($condition1 && $condition2 && $condition3) {
    // Traitement
}

// Mauvais exemple
class Utilisateur {
    public function inscription($donnees) {
        // Traitement d'inscription
        // Envoi de mail de confirmation
        // Ajout de l'utilisateur à la base de données
    }
}

// Bon exemple
class Utilisateur {
    public function inscription($donnees) {
        // Traitement d'inscription
    }
}

class ServiceMail {
    public function envoyerConfirmation($email) {
        // Envoi du mail de confirmation
    }
}

class ServiceBaseDonnees {
    public function ajouterUtilisateur($donnees) {
        // Ajout de l'utilisateur à la base de données
    }
}

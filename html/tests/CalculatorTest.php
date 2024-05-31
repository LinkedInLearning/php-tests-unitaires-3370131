<?php
// tests/CalculatorTest.php
use PHPUnit\Framework\TestCase;

require_once __DIR__ . '/../src/Calculator.php';

class CalculatorTest extends TestCase {

    // assertEquals(): Vérifie si deux valeurs sont égales.
    // assertNotEquals(): Vérifie si deux valeurs ne sont pas égales.
    // assertTrue(): Vérifie si une condition est vraie.
    // assertFalse(): Vérifie si une condition est fausse.
    // assertNull(): Vérifie si une valeur est nulle.
    // assertNotNull(): Vérifie si une valeur n'est pas nulle.
    // assertInstanceOf(): Vérifie si un objet est une instance d'une classe spécifique.

    // setUp(): Méthode utilisée pour effectuer des initialisations avant l'exécution de chaque test. Cela permet de réduire la duplication de code et de garantir un état initial cohérent pour chaque test.
    // tearDown(): Méthode utilisée pour nettoyer les ressources ou effectuer des actions de nettoyage après l'exécution de chaque test. Cela garantit une isolation correcte entre les tests et évite les effets de bord indésirables.
    // expectException(): Méthode utilisée pour tester si une exception spécifique est levée lors de l'exécution du code testé.

    protected $calculator;

    protected function setUp(): void {
        $this->calculator = new Calculator();
    }

    public function testAdd() {
        $this->assertEquals(4, $this->calculator->add(2, 2));
        $this->assertEquals(10, $this->calculator->add(5, 5));
    }

    public function testSubtract() {
        $this->assertEquals(3, $this->calculator->subtract(5, 2));
        $this->assertEquals(-2, $this->calculator->subtract(3, 5));
    }

    public function testMultiply() {
        $this->assertEquals(10, $this->calculator->multiply(2, 5));
        $this->assertEquals(-15, $this->calculator->multiply(3, -5));
    }

    public function testDivide() {
        $this->assertEquals(2, $this->calculator->divide(6, 3));
        $this->assertEquals(3, $this->calculator->divide(9, 3));
    }

    public function testDivideByZero() {
        $this->expectException(InvalidArgumentException::class);
        $this->calculator->divide(6, 0);
    }
}

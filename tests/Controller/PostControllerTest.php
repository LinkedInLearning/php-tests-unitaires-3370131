<?php

namespace App\Tests\Controller;

use App\Entity\Post;
use App\Form\PostType;
use Doctrine\ORM\EntityManagerInterface;
use Doctrine\ORM\EntityRepository;
use Symfony\Bundle\FrameworkBundle\KernelBrowser;
use Symfony\Component\Form\Test\TypeTestCase;

class PostControllerTest extends TypeTestCase
{
    private string $path = '/post/';

    public function testCreatePost()
    {
        $formData = array(
            'title' => 'Test Post',
            'description' => 'Description of test post'
        );

        $objectToCompare = new Post();
        // $objectToCompare will retrieve data from the form submission; pass it as the second argument
        $form = $this->factory->create(PostType::class, $objectToCompare);

        $object = new Post();
        $object->setTitle($formData['title']);
        $object->setDescription($formData['description']);

        // submit the data to the form directly
        $form->submit($formData);

        $this->assertTrue($form->isSynchronized());

        // check that $objectToCompare was modified as expected when the form was submitted
        $this->assertEquals($object, $objectToCompare);

        $view = $form->createView();
        $children = $view->children;

        foreach (array_keys($formData) as $key) {
            $this->assertArrayHasKey($key, $children);
        }
    }
}

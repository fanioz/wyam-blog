---
Title: ASP.NET Core API Unit Tests
Published: 5/19/2019
Tags: [Csharp, ASP.NET Core, Unit tests]
author: Johan Vergeer
---

ASP.NET Core API Controllers are just classes, which means they can be unit tested.

This can be explained best with an example. 

### Person Model

We'll start off with a `Person`  model.

<?# Gist 300a7aebba5bfd1b62f4fb2f468533ca /?>

This model has a `Name` and an `Age` property. It also has an `IsValid` property, returning whether the model is in a valid state. 
This last property will be used later when we will work on the `Post` request.

### IPersonRepository

I have only created the repository interface because an implementation is not required for these tests.
The methods are self-explanatory so I won't go into any detail here.

<?# Gist 89cb91b85a273bd5a472900f56988edf /?>

### PersonController

The `PersonController` serves as the API endpoint.
The `Get()` method returns all people from the repository, and the `Post()` method allows a new `Person` to be added to the repository. Note a `BadRequest` is returned when the `IsValid` property on the `Person` model is `false`. Also note the `IPersonRepository` interface is passed in to the constructor. I'll get back on this later when we'll look at the tests.

<?# Gist b515c0ff18a6bd695080f0c01190508d /?>

## Tests

<?# Note ?>
I'm using [xUnit.Net](https://xunit.net/), [FluentAssertions](https://fluentassertions.com/) and [Moq](https://github.com/Moq/moq4/wiki/Quickstart) for these tests.
<?#/ Note ?>

Let's have a look at the tests. As I stated before, we're passing in the `IPersonRepository` interface to the constructor of `PersonController`. But we don't have an implementation for `IPersonRepository`. This is on purpose, sinse we want to test the controllers implementation, and not an implementation of `IPersonRepository`.

For this reason we'll use [Moq](https://github.com/Moq/moq4/wiki/Quickstart), which is an awesome library we will use to create a mock `IPersonRepository`. The following code snippet shows how mock the repository is instantiated.

<?# Gist 11795a249d1589e0bd43ba3119366e47 /?>

### Get all people - empty list

For the first test we'll expect an empty list of `Person`. Before creating the `PersonController`, we have to setup the `Mock` object to return an empty `List<Person>` when `FindAll()` is called.

<?# Warning ?>
If we don't setup the mock, it will return null and throw an `ArgumentNullException` when `ToList()` is called in the controller.
<?#/ Warning ?>

After the controllers `Get()` method is called we assert the expected return type and whether the returned list is really empty.

<?# Gist ccafc0ad059dea8e01ff419eb69de555 /?>

### Get all people - people are returned

The next test we'll expect three `Person` objects. The `people` object we created is used in the `Returns()` method of the repository setup. This tells Moq to return the people whenever the `FindAll()` method is called on `IPersonRepository`.  

After the controllers `Get()` method is called we assert the expected return type again, but this time we expect three `Person` objects, which should be equivalent to the `people` object we passed into the `Returns()` method of the repository setup.

Now that this works, let's see how we can add a `Person`.

<?# Gist 3fda5518c8b97c6fa1c1045df5f22b8b /?>

### Post a person - Person has valid state

After retrieving people from the API, it would also be nice if we can add people. That will be tested next.

In this first test, which is a happy flow, the `Person` object will be added. Since the `Add()` method on `IPersonRepository` doesn't return anything, we don't have to do a setup. So we just `Post` a `Peron` object, after which we assert whether we response is an `OkObjectResult` and has a valid message. One thing we __do__ want to verify here though, is whether the `Add()` method was called on `IPersonRepository` once and only once.  

<?# Gist 1602b7cca1ab50b45480f1ffd0f64e98 /?>

### Post a person - Person has invalid state

In this last test, we have to see what happens if the `Person` doesn't have a valid state, which we'll test by not setting the `Name` property. In this case we assert whether the returned result is a `BadRequestObjectResult` and has a valid message. A more important assertion to note here is that we verify the `Add()` method on `IPersonRepository` is __Never__ called.

<?# Gist a0d88a8857827cdc7d7ff9c23d698beb /?>

## Conclusion

As you can see, we can test an API controller without any integration to other components of the application. We didn't even need an implementation for the repository. This way we have a fast and loosely coupled way to test our controllers.

The code for this project is located in the [GitHub repo](https://github.com/johanvergeer/ImJohan.Blog.AspNetCoreApiUnitTests).
# Unique Pointer

tags: #cpp #pointer #garbage_collect

## References

[cppreference](https://en.cppreference.com/w/cpp/memory/unique_ptr)
[ithelp](https://ithelp.ithome.com.tw/articles/10214031)

## About unique_pointer

> `std::unique_ptr` is a smart pointer that owns and manages another object through a pointer and disposes of that object when the `unique_ptr` goes out of scope.
>
> The object is disposed of, using the associated deleter when either of the following happens:
>
> - the managing `unique_ptr` object is destroyed
> - the managing `unique_ptr` object is assigned another pointer via [operator=](https://en.cppreference.com/w/cpp/memory/unique_ptr/operator%3D "cpp/memory/unique ptr/operator=") or [reset()](https://en.cppreference.com/w/cpp/memory/unique_ptr/reset "cpp/memory/unique ptr/reset").

In the past (before C++11), we had to manually delete the pointer after use.

```cpp
void test()
{
	Obj* obj = new Obj();
	// ...
	delete obj;
	return;
}
```

Unfortunately, C++ does not have a `defer` keyword(like [[Go Defer]]). Remembering to delete a pointer can be frustrating and prone to mistakes.
With the introduction of smart pointers in C++11, the issues with manual pointer deletion are resolved.

```cpp
void test()
{
	std::unique_ptr<Obj> obj = std::make_unique<Obj>();
	// ...
	return;
}
```

The `unique_ptr` manages the lifetime of the object and automatically deletes the object when it goes out of scope.

## Transfer the Ownership

### release()

In some cases, we may want to use the pointer in another scope, not just in the scope where it was created.

In such cases, we can use the `release()` method to transfer ownership of the `unique_ptr`.

```cpp
void test()
{
	std::unique_ptr<Obj> obj = std::make_unique<Obj>();
	Obj* objPtr = obj.release();
	// ...
	delete objPtr; // or you can pass the pointer to another scope and delete it there.
	return;
}
```

### std::move()

```cpp
void test()
{
	std::unique_ptr<Obj> obj = std::make_unique<Obj>();
	std::unique_ptr<Obj> anotherOne = std::move(obj);
	// ...
	return;
}

```

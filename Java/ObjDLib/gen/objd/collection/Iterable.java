package objd.collection;

import objd.lang.*;

public interface Iterable<T> extends Traversable<T> {
    int count();
    Iterator<T> iterator();
    @Override
    T head();
    boolean isEmpty();
    @Override
    void forEach(final P<T> each);
    @Override
    void parForEach(final P<T> each);
    @Override
    Go goOn(final F<T, Go> on);
    @Override
    boolean containsItem(final T item);
    @Override
    String toString();
    @Override
    int hashCode();
    boolean isEqualIterable(final Iterable<T> iterable);
    boolean equals(final Object to);
}
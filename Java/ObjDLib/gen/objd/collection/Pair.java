package objd.collection;

import objd.lang.*;

public final class Pair<T> extends ImSet_impl<T> {
    public final T a;
    public final T b;
    @Override
    public boolean containsItem(final T item) {
        return this.a.equals(item) || this.b.equals(item);
    }
    @Override
    public int count() {
        return ((int)(2));
    }
    @Override
    public Iterator<T> iterator() {
        return new PairIterator<T>(this);
    }
    @Override
    public T head() {
        return this.a;
    }
    public boolean isEqualPair(final Pair<T> pair) {
        final T __tmp__il_aitem = pair.a;
        final T __tmp__il_bitem = pair.b;
        return (this.a.equals(__tmp__il_aitem) || this.b.equals(__tmp__il_aitem)) && (this.a.equals(__tmp__il_bitem) || this.b.equals(__tmp__il_bitem));
    }
    @Override
    public int hashCode() {
        return (this.a.hashCode() + this.b.hashCode()) * 7 + 13;
    }
    public Pair(final T a, final T b) {
        this.a = a;
        this.b = b;
    }
    public String toString() {
        return String.format("Pair(%s, %s)", this.a, this.b);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null) {
            return false;
        }
        if(to instanceof Pair) {
            return isEqualPair(((Pair<T>)(((Pair)(to)))));
        }
        return false;
    }
}
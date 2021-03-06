package objd.collection;

import objd.lang.*;

public class MListItem<T> {
    public T data;
    public MListItem<T> next;
    public MListItem<T> prev;
    public MListItem(final T data) {
        this.data = data;
    }
    public String toString() {
        return String.format("MListItem(%s)", this.data);
    }
}
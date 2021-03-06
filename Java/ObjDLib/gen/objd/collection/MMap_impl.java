package objd.collection;

import objd.lang.*;

public abstract class MMap_impl<K, V> extends Map_impl<K, V> implements MMap<K, V> {
    public MMap_impl() {
    }
    @Override
    public void appendItem(final Tuple<K, V> item) {
        setKeyValue(item.a, item.b);
    }
    @Override
    public boolean removeItem(final Tuple<K, V> item) {
        return removeKey(item.a) != null;
    }
    @Override
    public ImMap<K, V> im() {
        return this.imCopy();
    }
    @Override
    public ImMap<K, V> imCopy() {
        final MHashMap<K, V> arr = new MHashMap<K, V>();
        {
            final Iterator<Tuple<K, V>> __il__1i = this.iterator();
            while(__il__1i.hasNext()) {
                final Tuple<K, V> item = __il__1i.next();
                arr.setKeyValue(item.a, item.b);
            }
        }
        return arr.im();
    }
    public V applyKeyOrUpdateWith(final K key, final F0<V> orUpdateWith) {
        final V __tmp = applyKey(key);
        if(__tmp != null) {
            return __tmp;
        } else {
            final V init = orUpdateWith.apply();
            setKeyValue(key, init);
            return init;
        }
    }
    public V modifyKeyBy(final K key, final F<V, V> by) {
        final V newObject = by.apply(applyKey(key));
        if(newObject == null) {
            removeKey(key);
        } else {
            setKeyValue(key, newObject);
        }
        return newObject;
    }
    public void assignImMap(final ImMap<K, V> imMap) {
        this.clear();
        {
            final Iterator<Tuple<K, V>> __il__1i = imMap.iterator();
            while(__il__1i.hasNext()) {
                final Tuple<K, V> _ = __il__1i.next();
                appendItem(_);
            }
        }
    }
    public void mutableFilterBy(final F<Tuple<K, V>, Boolean> by) {
        final MIterator<Tuple<K, V>> i = this.mutableIterator();
        while(i.hasNext()) {
            if(by.apply(i.next())) {
                i.remove();
            }
        }
    }
}
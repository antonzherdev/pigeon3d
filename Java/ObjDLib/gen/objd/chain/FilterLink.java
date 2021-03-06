package objd.chain;

import objd.lang.*;
import objd.collection.Go;

public class FilterLink<T> extends ChainLink_impl<T, T> {
    public final double factor;
    public final F<T, Boolean> predicate;
    @Override
    public Yield<T> buildYield(final Yield<T> yield) {
        return Yield.<T, T>decorateBaseBeginYield(yield, new F<Integer, Go>() {
            @Override
            public Go apply(final Integer size) {
                return yield.beginYieldWithSize(((int)(size * FilterLink.this.factor)));
            }
        }, new F<T, Go>() {
            @Override
            public Go apply(final T item) {
                if(FilterLink.this.predicate.apply(item)) {
                    return yield.yieldItem(item);
                } else {
                    return Go.Continue;
                }
            }
        });
    }
    public FilterLink(final double factor, final F<T, Boolean> predicate) {
        this.factor = factor;
        this.predicate = predicate;
    }
    public String toString() {
        return String.format("FilterLink(%f)", this.factor);
    }
}
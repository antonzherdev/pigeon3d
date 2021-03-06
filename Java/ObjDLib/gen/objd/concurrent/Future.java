package objd.concurrent;

import objd.lang.*;
import objd.collection.Traversable;

public abstract class Future<T> {
    public abstract Try<T> result();
    public abstract void onCompleteF(final P<Try<T>> f);
    public static <T> Future<T> applyF(final F0<T> f) {
        final Promise<T> p = Promise.<T>apply();
        DispatchQueue.aDefault.asyncF(new P0() {
            @Override
            public void apply() {
                p.successValue(f.apply());
            }
        });
        return p;
    }
    public static <A, B> Future<Tuple<A, B>> joinAB(final Future<A> a, final Future<B> b) {
        return ((Future<Tuple<A, B>>)(((Future)(Future.<A, B, Tuple<A, B>>mapABF(a, b, new F2<A, B, Tuple<A, B>>() {
            @Override
            public Tuple<A, B> apply(final A _a, final B _b) {
                return new Tuple<A, B>(_a, _b);
            }
        })))));
    }
    public static <A, B, C> Future<Tuple3<A, B, C>> joinABC(final Future<A> a, final Future<B> b, final Future<C> c) {
        return ((Future<Tuple3<A, B, C>>)(((Future)(Future.<A, B, C, Tuple3<A, B, C>>mapABCF(a, b, c, new F3<A, B, C, Tuple3<A, B, C>>() {
            @Override
            public Tuple3<A, B, C> apply(final A _a, final B _b, final C _c) {
                return new Tuple3<A, B, C>(_a, _b, _c);
            }
        })))));
    }
    public static <A, B, C, D> Future<Tuple4<A, B, C, D>> joinABCD(final Future<A> a, final Future<B> b, final Future<C> c, final Future<D> d) {
        return ((Future<Tuple4<A, B, C, D>>)(((Future)(Future.<A, B, C, D, Tuple4<A, B, C, D>>mapABCDF(a, b, c, d, new F4<A, B, C, D, Tuple4<A, B, C, D>>() {
            @Override
            public Tuple4<A, B, C, D> apply(final A _a, final B _b, final C _c, final D _d) {
                return new Tuple4<A, B, C, D>(_a, _b, _c, _d);
            }
        })))));
    }
    public static <A, B, C, D, E> Future<Tuple5<A, B, C, D, E>> joinABCDE(final Future<A> a, final Future<B> b, final Future<C> c, final Future<D> d, final Future<E> e) {
        return ((Future<Tuple5<A, B, C, D, E>>)(((Future)(Future.<A, B, C, D, E, Tuple5<A, B, C, D, E>>mapABCDEF(a, b, c, d, e, new F5<A, B, C, D, E, Tuple5<A, B, C, D, E>>() {
            @Override
            public Tuple5<A, B, C, D, E> apply(final A _a, final B _b, final C _c, final D _d, final E _e) {
                return new Tuple5<A, B, C, D, E>(_a, _b, _c, _d, _e);
            }
        })))));
    }
    public static <A, B, R> Future<R> mapABF(final Future<A> a, final Future<B> b, final F2<A, B, R> f) {
        final Promise<R> p = Promise.<R>apply();
        final MutVolatile<A> _a = new MutVolatile<A>(null);
        final MutVolatile<B> _b = new MutVolatile<B>(null);
        final AtomicInt n = new AtomicInt();
        a.onCompleteF(new P<Try<A>>() {
            @Override
            public void apply(final Try<A> t) {
                if(t.isSuccess()) {
                    _a.value = t.get();
                    if(n.incrementAndGet() == 2) {
                        p.successValue(f.apply(_a.value, _b.value));
                    }
                } else {
                    p.completeValue(((Try<R>)(((Try)(t)))));
                }
            }
        });
        b.onCompleteF(new P<Try<B>>() {
            @Override
            public void apply(final Try<B> t) {
                if(t.isSuccess()) {
                    _b.value = t.get();
                    if(n.incrementAndGet() == 2) {
                        p.successValue(f.apply(_a.value, _b.value));
                    }
                } else {
                    p.completeValue(((Try<R>)(((Try)(t)))));
                }
            }
        });
        return p;
    }
    public static <A, B, C, R> Future<R> mapABCF(final Future<A> a, final Future<B> b, final Future<C> c, final F3<A, B, C, R> f) {
        final Promise<R> p = Promise.<R>apply();
        final MutVolatile<A> _a = new MutVolatile<A>(null);
        final MutVolatile<B> _b = new MutVolatile<B>(null);
        final MutVolatile<C> _c = new MutVolatile<C>(null);
        final AtomicInt n = new AtomicInt();
        a.onCompleteF(new P<Try<A>>() {
            @Override
            public void apply(final Try<A> t) {
                if(t.isSuccess()) {
                    _a.value = t.get();
                    if(n.incrementAndGet() == 3) {
                        p.successValue(f.apply(_a.value, _b.value, _c.value));
                    }
                } else {
                    p.completeValue(((Try<R>)(((Try)(t)))));
                }
            }
        });
        b.onCompleteF(new P<Try<B>>() {
            @Override
            public void apply(final Try<B> t) {
                if(t.isSuccess()) {
                    _b.value = t.get();
                    if(n.incrementAndGet() == 3) {
                        p.successValue(f.apply(_a.value, _b.value, _c.value));
                    }
                } else {
                    p.completeValue(((Try<R>)(((Try)(t)))));
                }
            }
        });
        c.onCompleteF(new P<Try<C>>() {
            @Override
            public void apply(final Try<C> t) {
                if(t.isSuccess()) {
                    _c.value = t.get();
                    if(n.incrementAndGet() == 3) {
                        p.successValue(f.apply(_a.value, _b.value, _c.value));
                    }
                } else {
                    p.completeValue(((Try<R>)(((Try)(t)))));
                }
            }
        });
        return p;
    }
    public static <A, B, C, D, R> Future<R> mapABCDF(final Future<A> a, final Future<B> b, final Future<C> c, final Future<D> d, final F4<A, B, C, D, R> f) {
        final Promise<R> p = Promise.<R>apply();
        final MutVolatile<A> _a = new MutVolatile<A>(null);
        final MutVolatile<B> _b = new MutVolatile<B>(null);
        final MutVolatile<C> _c = new MutVolatile<C>(null);
        final MutVolatile<D> _d = new MutVolatile<D>(null);
        final AtomicInt n = new AtomicInt();
        a.onCompleteF(new P<Try<A>>() {
            @Override
            public void apply(final Try<A> t) {
                if(t.isSuccess()) {
                    _a.value = t.get();
                    if(n.incrementAndGet() == 4) {
                        p.successValue(f.apply(_a.value, _b.value, _c.value, _d.value));
                    }
                } else {
                    p.completeValue(((Try<R>)(((Try)(t)))));
                }
            }
        });
        b.onCompleteF(new P<Try<B>>() {
            @Override
            public void apply(final Try<B> t) {
                if(t.isSuccess()) {
                    _b.value = t.get();
                    if(n.incrementAndGet() == 4) {
                        p.successValue(f.apply(_a.value, _b.value, _c.value, _d.value));
                    }
                } else {
                    p.completeValue(((Try<R>)(((Try)(t)))));
                }
            }
        });
        c.onCompleteF(new P<Try<C>>() {
            @Override
            public void apply(final Try<C> t) {
                if(t.isSuccess()) {
                    _c.value = t.get();
                    if(n.incrementAndGet() == 4) {
                        p.successValue(f.apply(_a.value, _b.value, _c.value, _d.value));
                    }
                } else {
                    p.completeValue(((Try<R>)(((Try)(t)))));
                }
            }
        });
        d.onCompleteF(new P<Try<D>>() {
            @Override
            public void apply(final Try<D> t) {
                if(t.isSuccess()) {
                    _d.value = t.get();
                    if(n.incrementAndGet() == 4) {
                        p.successValue(f.apply(_a.value, _b.value, _c.value, _d.value));
                    }
                } else {
                    p.completeValue(((Try<R>)(((Try)(t)))));
                }
            }
        });
        return p;
    }
    public static <A, B, C, D, E, R> Future<R> mapABCDEF(final Future<A> a, final Future<B> b, final Future<C> c, final Future<D> d, final Future<E> e, final F5<A, B, C, D, E, R> f) {
        final Promise<R> p = Promise.<R>apply();
        final MutVolatile<A> _a = new MutVolatile<A>(null);
        final MutVolatile<B> _b = new MutVolatile<B>(null);
        final MutVolatile<C> _c = new MutVolatile<C>(null);
        final MutVolatile<D> _d = new MutVolatile<D>(null);
        final MutVolatile<E> _e = new MutVolatile<E>(null);
        final AtomicInt n = new AtomicInt();
        a.onCompleteF(new P<Try<A>>() {
            @Override
            public void apply(final Try<A> t) {
                if(t.isSuccess()) {
                    _a.value = t.get();
                    if(n.incrementAndGet() == 5) {
                        p.successValue(f.apply(_a.value, _b.value, _c.value, _d.value, _e.value));
                    }
                } else {
                    p.completeValue(((Try<R>)(((Try)(t)))));
                }
            }
        });
        b.onCompleteF(new P<Try<B>>() {
            @Override
            public void apply(final Try<B> t) {
                if(t.isSuccess()) {
                    _b.value = t.get();
                    if(n.incrementAndGet() == 5) {
                        p.successValue(f.apply(_a.value, _b.value, _c.value, _d.value, _e.value));
                    }
                } else {
                    p.completeValue(((Try<R>)(((Try)(t)))));
                }
            }
        });
        c.onCompleteF(new P<Try<C>>() {
            @Override
            public void apply(final Try<C> t) {
                if(t.isSuccess()) {
                    _c.value = t.get();
                    if(n.incrementAndGet() == 5) {
                        p.successValue(f.apply(_a.value, _b.value, _c.value, _d.value, _e.value));
                    }
                } else {
                    p.completeValue(((Try<R>)(((Try)(t)))));
                }
            }
        });
        d.onCompleteF(new P<Try<D>>() {
            @Override
            public void apply(final Try<D> t) {
                if(t.isSuccess()) {
                    _d.value = t.get();
                    if(n.incrementAndGet() == 5) {
                        p.successValue(f.apply(_a.value, _b.value, _c.value, _d.value, _e.value));
                    }
                } else {
                    p.completeValue(((Try<R>)(((Try)(t)))));
                }
            }
        });
        e.onCompleteF(new P<Try<E>>() {
            @Override
            public void apply(final Try<E> t) {
                if(t.isSuccess()) {
                    _e.value = t.get();
                    if(n.incrementAndGet() == 5) {
                        p.successValue(f.apply(_a.value, _b.value, _c.value, _d.value, _e.value));
                    }
                } else {
                    p.completeValue(((Try<R>)(((Try)(t)))));
                }
            }
        });
        return p;
    }
    public static <T> Future<T> successfulResult(final T result) {
        return new KeptPromise<T>(new Success<T>(result));
    }
    public boolean isCompleted() {
        return this.result() != null;
    }
    public boolean isSucceeded() {
        final Try<T> __tmp = this.result();
        if(__tmp != null) {
            return this.result().isSuccess();
        } else {
            return false;
        }
    }
    public boolean isFailed() {
        final Try<T> __tmp = this.result();
        if(__tmp != null) {
            return this.result().isFailure();
        } else {
            return true;
        }
    }
    public void onSuccessF(final P<T> f) {
        onCompleteF(new P<Try<T>>() {
            @Override
            public void apply(final Try<T> t) {
                if(t.isSuccess()) {
                    f.apply(t.get());
                }
            }
        });
    }
    public void onFailureF(final P<Object> f) {
        onCompleteF(new P<Try<T>>() {
            @Override
            public void apply(final Try<T> t) {
                if(t.isFailure()) {
                    f.apply(t.reason());
                }
            }
        });
    }
    public <R> Future<R> mapF(final F<T, R> f) {
        final Promise<R> p = Promise.<R>apply();
        onCompleteF(new P<Try<T>>() {
            @Override
            public void apply(final Try<T> tr) {
                p.completeValue(tr.<R>mapF(f));
            }
        });
        return p;
    }
    public Future<Void> forF(final P<T> f) {
        final Promise<Void> p = Promise.<Void>apply();
        onCompleteF(new P<Try<T>>() {
            @Override
            public void apply(final Try<T> tr) {
                if(tr.isSuccess()) {
                    f.apply(tr.get());
                    p.successValue(null);
                } else {
                    p.completeValue(((Try<Void>)(((Try)(tr)))));
                }
            }
        });
        return p;
    }
    public <R> Future<R> flatMapF(final F<T, Future<R>> f) {
        final Promise<R> p = Promise.<R>apply();
        onCompleteF(new P<Try<T>>() {
            @Override
            public void apply(final Try<T> tr) {
                if(tr.isFailure()) {
                    p.completeValue(((Try<R>)(((Try)(tr)))));
                } else {
                    final Future<R> fut = f.apply(tr.get());
                    fut.onCompleteF(new P<Try<R>>() {
                        @Override
                        public void apply(final Try<R> ftr) {
                            p.completeValue(ftr);
                        }
                    });
                }
            }
        });
        return p;
    }
    public Try<T> waitResultPeriod(final double period) {
        final ConditionLock lock = new ConditionLock(0);
        onCompleteF(new P<Try<T>>() {
            @Override
            public void apply(final Try<T> _) {
                lock.lock();
                lock.unlockWithCondition(1);
            }
        });
        if(lock.lockWhenConditionPeriod(1, period)) {
            lock.unlock();
        }
        return this.result();
    }
    public Try<T> waitResult() {
        final ConditionLock lock = new ConditionLock(0);
        onCompleteF(new P<Try<T>>() {
            @Override
            public void apply(final Try<T> _) {
                lock.lock();
                lock.unlockWithCondition(1);
            }
        });
        lock.lockWhenCondition(1);
        lock.unlock();
        final Try<T> __tmp_4n = this.result();
        if(__tmp_4n == null) {
            throw new NullPointerException();
        }
        return __tmp_4n;
    }
    public void waitAndOnSuccessAwaitF(final double await, final P<T> f) {
        {
            final Try<T> __tr = waitResultPeriod(await);
            if(__tr != null) {
                if(__tr.isSuccess()) {
                    f.apply(__tr.get());
                }
            }
        }
    }
    public <I> void waitAndOnSuccessFlatAwaitF(final double await, final P<I> f) {
        {
            {
                final Try<Traversable<I>> __il__0__tr = ((Future<Traversable<I>>)(((Future)(this)))).waitResultPeriod(await);
                if(__il__0__tr != null) {
                    if(__il__0__tr.isSuccess()) {
                        {
                            final Traversable<I> __tr2 = __il__0__tr.get();
                            ((Traversable<I>)(((Traversable)(__tr2)))).forEach(f);
                        }
                    }
                }
            }
        }
    }
    public T getResultAwait(final double await) {
        final Try<T> __tmpln = waitResultPeriod(await);
        if(__tmpln == null) {
            throw new NullPointerException();
        }
        return __tmpln.get();
    }
    public <R> Future<Tuple<T, R>> joinAnother(final Future<R> another) {
        final Promise<Tuple<T, R>> p = Promise.<Tuple<T, R>>apply();
        final MutVolatile<T> a = new MutVolatile<T>(null);
        final MutVolatile<R> b = new MutVolatile<R>(null);
        final AtomicInt n = new AtomicInt();
        onCompleteF(new P<Try<T>>() {
            @Override
            public void apply(final Try<T> t) {
                if(t.isSuccess()) {
                    a.value = t.get();
                    if(n.incrementAndGet() == 2) {
                        p.successValue(new Tuple<T, R>(a.value, b.value));
                    }
                } else {
                    p.completeValue(((Try<Tuple<T, R>>)(((Try)(t)))));
                }
            }
        });
        another.onCompleteF(new P<Try<R>>() {
            @Override
            public void apply(final Try<R> t) {
                if(t.isSuccess()) {
                    b.value = t.get();
                    if(n.incrementAndGet() == 2) {
                        p.successValue(new Tuple<T, R>(a.value, b.value));
                    }
                } else {
                    p.completeValue(((Try<Tuple<T, R>>)(((Try)(t)))));
                }
            }
        });
        return p;
    }
    public Future() {
    }
    public String toString() {
        return "Future";
    }
}
package com.pigeon3d;

import objd.lang.*;

public final class ShareItem {
    public final String text;
    public final String subject;
    public static ShareItem applyText(final String text) {
        return new ShareItem(text, null);
    }
    public ShareItem(final String text, final String subject) {
        this.text = text;
        this.subject = subject;
    }
    public String toString() {
        return String.format("ShareItem(%s, %s)", this.text, this.subject);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof ShareItem)) {
            return false;
        }
        final ShareItem o = ((ShareItem)(to));
        return this.text.equals(o.text) && this.subject.equals(o.subject);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + new StringEx(this.text).hashCode();
        hash = hash * 31 + this.subject.hashCode();
        return hash;
    }
}
package com.pigeon3d;

import objd.lang.*;
import objd.collection.ImHashMap;

public final class ShareContent {
    public final String text;
    public final String image;
    public final ImHashMap<ShareChannel, ShareItem> items;
    public static ShareContent applyTextImage(final String text, final String image) {
        return new ShareContent(text, image, ERROR: Unknown []);
    }
    public ShareContent addChannelText(final ShareChannel channel, final String text) {
        return addChannelTextSubject(channel, text, null);
    }
    public ShareContent addChannelTextSubject(final ShareChannel channel, final String text, final String subject) {
        return new ShareContent(this.text, this.image, this.items.addItem(new Tuple<ShareChannel, ShareItem>(channel, new ShareItem(text, subject))));
    }
    public ShareContent twitterText(final String text) {
        return addChannelText(ShareChannel.twitter, text);
    }
    public ShareContent facebookText(final String text) {
        return addChannelText(ShareChannel.facebook, text);
    }
    public ShareContent emailTextSubject(final String text, final String subject) {
        return addChannelTextSubject(ShareChannel.email, text, subject);
    }
    public ShareContent messageText(final String text) {
        return addChannelText(ShareChannel.message, text);
    }
    public String textChannel(final ShareChannel channel) {
        final ShareItem __tmp = this.items.applyKey(channel);
        if(__tmp != null) {
            return this.items.applyKey(channel).text;
        } else {
            return this.text;
        }
    }
    public String subjectChannel(final ShareChannel channel) {
        final ShareItem __tmpu = this.items.applyKey(channel);
        return ((__tmpu != null) ? (__tmpu.subject) : (null));
    }
    public String imageChannel(final ShareChannel channel) {
        return this.image;
    }
    public ShareDialog dialog() {
        return new ShareDialog(this, new P<ShareChannel>() {
            @Override
            public void apply(final ShareChannel _) {
            }
        }, new P0() {
            @Override
            public void apply() {
            }
        });
    }
    public ShareDialog dialogShareHandlerCancelHandler(final P<ShareChannel> shareHandler, final P0 cancelHandler) {
        return new ShareDialog(this, shareHandler, cancelHandler);
    }
    public ShareContent(final String text, final String image, final ImHashMap<ShareChannel, ShareItem> items) {
        this.text = text;
        this.image = image;
        this.items = items;
    }
    public String toString() {
        return String.format("ShareContent(%s, %s, %s)", this.text, this.image, this.items);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof ShareContent)) {
            return false;
        }
        final ShareContent o = ((ShareContent)(to));
        return this.text.equals(o.text) && this.image.equals(o.image) && this.items.equals(o.items);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + new StringEx(this.text).hashCode();
        hash = hash * 31 + this.image.hashCode();
        hash = hash * 31 + this.items.hashCode();
        return hash;
    }
}
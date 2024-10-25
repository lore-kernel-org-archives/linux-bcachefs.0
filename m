Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17870217F4A;
	Fri, 25 Oct 2024 21:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729891591; cv=none; b=Wo0/zqNp9ivOf/VInSl5MPW2xOyyzN3eynF1P4F+WLSTGNUNX1A7UDUkc+0MRY7E+RBXs8yh8kJVgVSVgkC5kXFNyBe3pRSOpdQcf3azLDs/U50hVGA2uex9ZOwrJLbBxyg31yoU8a/aRgUua0qChpgasV19t4Kx3UUdZDeJ598=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729891591; c=relaxed/simple;
	bh=KcIaVgPkw+hE3Yu4bPeVYuAuBk96QgsL9DKxY5WuKSU=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=jT1JxGK50WHiK0VJ+1dtDqLtcqBZ7laGMuBEqx71kh+1YHaq4LmtIzPH6lRFVurD3I14vZiIKBPy0e7RCYQEoFFqipeFtpvT3tICgyikvdJOd1p1WTD08bVeEvE2XTTCSiN3PPNWRc+Y25kRhdgM2w8QUKSR+EK2MrQ/PZ5WNnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Received: from quad.stoffel.org (syn-097-095-183-072.res.spectrum.com [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 7E1F81E11C;
	Fri, 25 Oct 2024 17:26:21 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id D8984A0A9A; Fri, 25 Oct 2024 17:26:19 -0400 (EDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <26396.3323.858567.266417@quad.stoffel.home>
Date: Fri, 25 Oct 2024 17:26:19 -0400
From: "John Stoffel" <john@stoffel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: John Stoffel <john@stoffel.org>,
    manas18244@iiitd.ac.in,
    linux-bcachefs@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    Anup Sharma <anupnewsmail@gmail.com>,
    Shuah Khan <skhan@linuxfoundation.org>,
    syzbot+e8eff054face85d7ea41@syzkaller.appspotmail.com
X-Clacks-Overhead: GNU Terry Pratchett
Subject: Re: [PATCH] Revert "bcachefs: Add asserts to
 bch2_dev_btree_bitmap_marked_sectors()"
In-Reply-To: <bv4dfgmq4wmfcon2thkvhthqjlrpr5h4nmhfuusj4lh2wrj5ao@ckmvt63s67r6>
References: <20241021-revert-assert-bch2-v1-1-e869c7c55bb6@iiitd.ac.in>
	<rd4maufxfunrcpzkoo2jszorzl256fiktw3p5yfpnjpu2ajh4l@5wvkfxwzajax>
	<26394.37450.21740.720541@quad.stoffel.home>
	<bv4dfgmq4wmfcon2thkvhthqjlrpr5h4nmhfuusj4lh2wrj5ao@ckmvt63s67r6>
X-Mailer: VM 8.3.x under 28.2 (x86_64-pc-linux-gnu)

>>>>> "Kent" == Kent Overstreet <kent.overstreet@linux.dev> writes:

> On Thu, Oct 24, 2024 at 02:30:34PM -0400, John Stoffel wrote:
>> >>>>> "Kent" == Kent Overstreet <kent.overstreet@linux.dev> writes:
>> 
>> > On Mon, Oct 21, 2024 at 10:18:57PM +0530, Manas via B4 Relay wrote:
>> >> From: Manas <manas18244@iiitd.ac.in>
>> >> 
>> >> This reverts commit 60f2b1bcf519416dbffee219132aa949d0c39d0e.
>> >> 
>> >> This syzbot bug[1] is triggered due to the BUG_ON assertions added in
>> >> __bch2_dev_btree_bitmap_mark. During runtime, m->btree_bitmap_shift is
>> >> 63 '?'. This triggers both the assertions.
>> 
>> > The BUG_ON() doesn't need to be deleted; we just need to fix the
>> > validation so it doesn't fire (it doesn't particularly matter if it's
>> > removed or not, ubsan would catch it without the BUG_ON()).
>> 
>> Shouldn't the BUG_ON() be replaced with making the filesystem readonly
>> instead if you're going to keep it?  I'd rather have the filesystem
>> still be mounted and able to be read, but not writeable, instead of
>> having my system crash before I can do anything.  

> Not in this case. In general, if there's a chance of the BUG_ON()
> hitting in the wild after the code has passed testing then it
> shouldn't be a BUG_ON(), but this is low level validation that we're
> relying on.

So I'm having a hard time parsing this reply.  And I don't think you
make a good case for leaving or even having a BUG_ON() here at all.
If there's a chance of it hitting in the wild, it should be removed.
But you don't want to remove it because it will never hit?  That's
just lazy... :-)   I just don't see why a filesystem should have the
opportunity to kill an entire system because that one filesystem has
problems.  

> In general higher level code absolutely requires that the low level
> validation is correct, because if it's not that will trigger all sorts
> of undefined behaviour in the upper layers.

> By "low level validation" I mean _only_ the validate functions that
> check simple invariants within a single data type that is read or
> written atomically to disk - "is data type garbage or not".

Sure.

> If it's an invariant that involves multiple objects - "does this
> extent refer to a valid device/snapshot ID" - that's not something
> we can check in validate, because then an extent or what have you
> would become invalid depending on what happens in the rest of the
> filesystem. Those sorts of checks do in fact need proper error
> paths.

Right. 

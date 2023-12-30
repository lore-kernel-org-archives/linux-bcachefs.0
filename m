Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CFE10EB
	for <linux-bcachefs@vger.kernel.org>; Sat, 30 Dec 2023 03:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kode54.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kode54.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kode54.net header.i=@kode54.net header.b="JDxRlXsF";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="0HqGBSjj"
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id BEE3B5C01A8;
	Fri, 29 Dec 2023 22:29:56 -0500 (EST)
Received: from imap44 ([10.202.2.94])
  by compute1.internal (MEProxy); Fri, 29 Dec 2023 22:29:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kode54.net; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1703906996; x=1703993396; bh=6qWlHhA+u+
	/loFKAjbsn+4shtio9fVFEPm5Ov+zzFNE=; b=JDxRlXsFqxLlijBFcApaw26bc1
	JRmmOAfd0zYk6GPU4bVcc44RQ8ahcpXxUDKlu4ZDE8SQDIcAkdhXIDPYmRrdHnum
	3/FMRlU80bJ3e74WSoDr+Fq24s4+OnR5sxlmUOHDtwHJKmqsD4qQMyp6Mj3uVUSb
	UUI+N8bj7qQLrS9FPQ701podnYdZIS+QcUdJzbOHttwlpywW68mo++1+uS8DDDYO
	q4/DS9wX4XKMgryQy0PUPTgmQSKbyG/f51mfZooeUZnrbVyFie2HFhSmrIhgFJdA
	obmgFzWJ4COhBwfJlnp8wkiKUqoXztNWize9XdDKGsh9WM6HT7OYk3NBXO9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1703906996; x=1703993396; bh=6qWlHhA+u+/loFKAjbsn+4shtio9
	fVFEPm5Ov+zzFNE=; b=0HqGBSjj3ZVHDkQ3ZMsF67uODdjrYBw8q8fjdedV92FF
	inaRSFkdAxasfpTauvR9VEUzLPo+F/0GZAXd2nBt6Ua3nLzn4a1hLYimvJ2+m5Tp
	fi3TBbQ1D/YjE6latNXdrHR0TrVtTDQyL6+/UBNJA7/Sn2u+G1mqm+0zQR+C0tsr
	hxQvxeszJFghzcRXC0b0cXfG2t9jcLFU/HCnTPfD04GLpjRN5OR4iQQxt5CyWvdk
	IaHb4E5yNOTC/thEm1MDW7tTCPZ2RfmpBPKLaBPaCB+oY9rKgl3bQ79EUrryj9Fp
	E2+RHOQqIZ2vjAkydbl8m3X3tmy02gj5MVWOkBJ3kQ==
X-ME-Sender: <xms:tI6PZSL73K-sjEIuU5aSIrIun8cRQAvh--rx2OciscqTD0GTIfosXw>
    <xme:tI6PZaKVBbITdkixT1B14wSVrEiCjYodshhhBySDnSCqPffXOxzqKfOOww2JPfzAW
    7A-uH-Hnmur-d0MUOI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedrvdefgedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedfvehh
    rhhishhtohhphhgvrhcuufhnohifhhhilhhlfdcuoegthhhrihhssehkohguvgehgedrnh
    gvtheqnecuggftrfgrthhtvghrnhepgfduuddvlefhtefglefhgedtveffleelgedugeel
    udevgfffiefgvdegheeuudejnecuffhomhgrihhnpegvvhhilhhpihgvphhirhgrthgvrd
    horhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    tghhrhhisheskhhouggvheegrdhnvght
X-ME-Proxy: <xmx:tI6PZSuaiDWDNt6hNnkgbHuytnXBPPELBvyRH6CuTCukQ26Z6eQGlA>
    <xmx:tI6PZXayMzTDZLLkzM6wYRRNYeCqnAuM9S8CUa6f_reJF8zKC8HbhQ>
    <xmx:tI6PZZbEZMEeGKxY6T2FtF30qAXtHUA9dfLFc6nyyUjF7ag2EkPDdQ>
    <xmx:tI6PZaCx4OPn0Oznm1bSsjFaWxzLhQgU_WuEOSnDhRJL24xx5hyM6Q>
Feedback-ID: i01794759:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 7532E36A0076; Fri, 29 Dec 2023 22:29:56 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-1364-ga51d5fd3b7-fm-20231219.001-ga51d5fd3
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <b7228c18-fc7f-4ddc-83b5-3b442ed29446@app.fastmail.com>
In-Reply-To: <513708765.544.1703882679194@mail.carlthompson.net>
References: <1804957404.243.1703798376220@mail.carlthompson.net>
 <evltrlnkclj3g3yqm2nqyfz63tg53ojxs45uouq5e6nosxz37z@rxqrn6smqmuc>
 <513708765.544.1703882679194@mail.carlthompson.net>
Date: Fri, 29 Dec 2023 19:29:24 -0800
From: "Christopher Snowhill" <chris@kode54.net>
To: "Carl E. Thompson" <list-bcachefs@carlthompson.net>,
 "Kent Overstreet" <kent.overstreet@linux.dev>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: bcachefs subvols / snapshots broken
Content-Type: text/plain

On Fri, Dec 29, 2023, at 12:44 PM, Carl E. Thompson wrote:
> I don't see anything recent on the -testing branch on GitHub so I 
> applied the patch from your email and the other io_write.c patch 
> directly to rc7.

As far as I know, the official repository is:

https://evilpiepirate.org/git/bcachefs.git

And GitHub is a mirror of this.

>
> So far it seems to work to fix this issue for me. I'll keep testing. 
> Thanks for such a quick fix!
>
> Thank you,
> Carl Thompson
>
>
>> On 2023-12-29 10:50 AM PST Kent Overstreet <kent.overstreet@linux.dev> wrote:
>> ...
>> Fix is in the -testing branch, will be making it to the appropriate
>> places shortly:
>> 
>> commit 05b11fb627bcd71cc19e79cdeabfa1b514bf8acf
>> Author: Kent Overstreet <kent.overstreet@linux.dev>
>> Date:   Fri Dec 29 13:39:07 2023 -0500
>> 
>>     bcachefs: Fix extents iteration + snapshots interaction
>>     
>>     peek_upto() checks against the end position and bails out before
>>     FILTER_SNAPSHOTS checks; this is because if we end up at a different
>>     inode number than the original search key none of the keys we see might
>>     be visibile in the current snapshot - we might be looking at inode in a
>>     completely different subvolume.
>>     
>>     But this is broken, because when we're iterating over extents we're
>>     checking against the extent start position to decide when to bail out,
>>     and the extent start position isn't monotonically increasing until after
>>     we've run FILTER_SNAPSHOTS.
>>     
>>     Fix this by adding a simple inode number check where the old bailout
>>     check was, and moving the main check to the correct position.
>>     
>>     Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
>> 
>> diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
>> index 732c8bb3f803..7e5c797cfaf2 100644
>> --- a/fs/bcachefs/btree_iter.c
>> +++ b/fs/bcachefs/btree_iter.c
>> @@ -2145,18 +2145,16 @@ struct bkey_s_c bch2_btree_iter_peek_upto(struct btree_iter *iter, struct bpos e
>>  			goto out_no_locked;
>>  
>>  		/*
>> -		 * iter->pos should be mononotically increasing, and always be
>> -		 * equal to the key we just returned - except extents can
>> -		 * straddle iter->pos:
>> +		 * We need to check against @end before FILTER_SNAPSHOTS because
>> +		 * if we get to a different inode that requested we might be
>> +		 * seeing keys for a different snapshot tree that will all be
>> +		 * filtered out.
>> +		 *
>> +		 * But we can't do the full check here, because bkey_start_pos()
>> +		 * isn't monotonically increasing before FILTER_SNAPSHOTS, and
>> +		 * that's what we check against in extents mode:
>>  		 */
>> -		if (!(iter->flags & BTREE_ITER_IS_EXTENTS))
>> -			iter_pos = k.k->p;
>> -		else
>> -			iter_pos = bkey_max(iter->pos, bkey_start_pos(k.k));
>> -
>> -		if (unlikely(!(iter->flags & BTREE_ITER_IS_EXTENTS)
>> -			     ? bkey_gt(iter_pos, end)
>> -			     : bkey_ge(iter_pos, end)))
>> +		if (k.k->p.inode > end.inode)
>>  			goto end;
>>  
>>  		if (iter->update_path &&
>> @@ -2215,6 +2213,21 @@ struct bkey_s_c bch2_btree_iter_peek_upto(struct btree_iter *iter, struct bpos e
>>  			continue;
>>  		}
>>  
>> +		/*
>> +		 * iter->pos should be mononotically increasing, and always be
>> +		 * equal to the key we just returned - except extents can
>> +		 * straddle iter->pos:
>> +		 */
>> +		if (!(iter->flags & BTREE_ITER_IS_EXTENTS))
>> +			iter_pos = k.k->p;
>> +		else
>> +			iter_pos = bkey_max(iter->pos, bkey_start_pos(k.k));
>> +
>> +		if (unlikely(!(iter->flags & BTREE_ITER_IS_EXTENTS)
>> +			     ? bkey_gt(iter_pos, end)
>> +			     : bkey_ge(iter_pos, end)))
>> +			goto end;
>> +
>>  		break;
>>  	}

Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8574317FD;
	Wed, 10 Jul 2024 11:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720609367; cv=none; b=SCXHxKwsuuuULP4MgFUHwKt6zwLcf6pNvbSKSudEywKRU/AOM4tl2R3qMepT6YJ5S3OJFSkGU/3+tVeAE/ZVygU/JwYulJFseR5DlpDhtWVkBw4SFvzHN/H/rhAKXo3vMAVEh8iL5LLihm1qA+E7xnsIW/u+0OFXeyZI+mbXG88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720609367; c=relaxed/simple;
	bh=MB5RUz9En8zgRblZi0YlJjmBHs76SzaICxSLYusWtHk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=rZ1LHNeDO6N0JO1mAQNN5s5q47OxcgypGttfKfbcYlv9mPaYyUHkgi1pksdC1Ayhvh4iY9Zc3h3KvehxnYHcWd8wywEQAISf5clMSbg3Y9pNKnO2tgB1L2re7zEBw372w/Yj/cQ6cr/rpwydznpkUDf0KWifEAOeV/rUxgBM10g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=0i+BFO8H; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=TnWTzxN7; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="0i+BFO8H";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="TnWTzxN7"
From: John Ogness <john.ogness@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1720609363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MB5RUz9En8zgRblZi0YlJjmBHs76SzaICxSLYusWtHk=;
	b=0i+BFO8HLrjhBE23gu5RU+VP//VQGx7vfP0Ussd6Mzs7fmI3MqZqwtO6gVraOzZCvzj5Wt
	ZdJhW0mKwWTZTg81dyZ+K3lzM/1zbhtUYuxGB1mng0bqo+jpgGLF2H6/rT0TsntP71GQ2X
	xA1WBNl/6HUoW8WaIwYYqCBZd4j1cZ/XyDqsDmA4H239njnXMnZZVe7XGYV97e9XD965ln
	Mn31S1LGxBAOCqyVN5OLGvXXRagN+qKfAk8jxP9T6BA/dCb/CA8po7LZypucSu1Px0VM8D
	9XiFu+O4p9AjP5OZMqvI8lP7AXbqNZhEcYlkIvW0uC9lPZ9nvDVPKFsQ0h5TWQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1720609363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MB5RUz9En8zgRblZi0YlJjmBHs76SzaICxSLYusWtHk=;
	b=TnWTzxN7PjYBExaJdixfiCKsoQwmIaEjW23sPMzLsrosGcAODgfoVfcEiLCXyuKTmu3ay6
	BNX61qresqLc2bDw==
To: Daniel Vetter <daniel.vetter@ffwll.ch>, DRI Development
 <dri-devel@lists.freedesktop.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>, Daniel
 Vetter <daniel.vetter@ffwll.ch>,
 syzbot+6cebc1af246fe020a2f0@syzkaller.appspotmail.com, Daniel Vetter
 <daniel.vetter@intel.com>, stable@vger.kernel.org, Kent Overstreet
 <kent.overstreet@linux.dev>, Brian Foster <bfoster@redhat.com>,
 linux-bcachefs@vger.kernel.org, Petr Mladek <pmladek@suse.com>, Steven
 Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky
 <senozhatsky@chromium.org>
Subject: Re: [PATCH 2/2] bcachefs: only console_trylock in
 bch2_print_string_as_lines
In-Reply-To: <20240710093120.732208-2-daniel.vetter@ffwll.ch>
References: <20240710093120.732208-1-daniel.vetter@ffwll.ch>
 <20240710093120.732208-2-daniel.vetter@ffwll.ch>
Date: Wed, 10 Jul 2024 13:08:42 +0206
Message-ID: <87frsh33xp.fsf@jogness.linutronix.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On 2024-07-10, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> console_lock is the outermost subsystem lock for a lot of subsystems,
> which means get/put_user must nest within. Which means it cannot be
> acquired somewhere deeply nested in other locks, and most definitely
> not while holding fs locks potentially needed to resolve faults.
>
> console_trylock is the best we can do here.
>
> Including printk folks since even trylock feels realyl iffy here to
> me.

Using the console lock here at all is wrong. The console lock does not
prevent other CPUs from calling printk() and inserting lines in between.

There is no way to guarantee a contiguous ringbuffer block using
multiple printk() calls.

The console_lock usage should be removed.

John Ogness

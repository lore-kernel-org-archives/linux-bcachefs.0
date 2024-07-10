Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FDC194081;
	Wed, 10 Jul 2024 14:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720620105; cv=none; b=cYyibn0CJrdrFBEkJ25U/DtbK0LBB2daDELksLHNhHFpW1UN+KjugFn+Y9/o4CBRsDCfN31IP9KWZAXO2uAwux8zRqD0yW0bjw/Qqejz/2/zr0w54YP4GN2yjn8z8JEJdbp/RKlKr4PJP6MZlVg/rAEI5Nvy9pfWgPP0f2seFik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720620105; c=relaxed/simple;
	bh=Et5l8wbkPTW0SmqvPS5ISuDSY1IwQ9qONGjNBZSNKw8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=StDK6p3gS8kQENoItWxU3hb2y88eFkhHzJKypNXoToOw6WibZIss8jKOpQKvMnBgotrSyeNmN7eeTZjFOs23S1EMMEb2Dj9N2u0AHg9ONIqNpeHs02XrZYxW8tLzy5vcoZszehmDPhJE2dr4xJrZwU6DAApZvvX4rPZ70tVzkzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=vnFhuSC2; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=VKGXipAt; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="vnFhuSC2";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="VKGXipAt"
From: John Ogness <john.ogness@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1720620101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Et5l8wbkPTW0SmqvPS5ISuDSY1IwQ9qONGjNBZSNKw8=;
	b=vnFhuSC2VBqWV9SCWATEZgz7pyFBe16UTJe9kG87ame65DQs7Cpwzd+Ij9ZbnNVeaR/IiT
	/Oq0DD9eDwsGSTTodj0iebvYq01hcrcMzS8nVuvXWa2Osu3HMINl0QTrsKPNGWxJPKSI5a
	pH76lB8eyILBpE5x6JzJ0/BWYOVSDaQEx5M5bWVhUpa8Yq6nRfv2VzlShVVKdbAzXhmq9J
	tLqBek4Bo2enxYjDG/Znjh2Ezj5psXeH4oHsXNRm6FHrWqTnPAUs8tNyX1EFsJbyLwn//6
	itpGSqTcloqgNM4qAfZTdXuiQKNbjiXc7JZ29RQjAxySdPLvR1duPpzSQolyyA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1720620101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Et5l8wbkPTW0SmqvPS5ISuDSY1IwQ9qONGjNBZSNKw8=;
	b=VKGXipAtKYmyYCqcpqINqZlTwQXUNbLuV9OyyCIIf1AjQo0+T0C60xxIM+jLY6x5O1tO8z
	bhiXrHPkG722RfDA==
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
Subject: Re: [PATCH] bcachefs: no console_lock in bch2_print_string_as_lines
In-Reply-To: <20240710130335.765885-1-daniel.vetter@ffwll.ch>
References: <20240710093120.732208-2-daniel.vetter@ffwll.ch>
 <20240710130335.765885-1-daniel.vetter@ffwll.ch>
Date: Wed, 10 Jul 2024 16:07:40 +0206
Message-ID: <87o775cpmj.fsf@jogness.linutronix.de>
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
> console_trylock is the best we can do here. But John pointed out on a
> previous version that this is futile:
>
> "Using the console lock here at all is wrong. The console lock does not
> prevent other CPUs from calling printk() and inserting lines in between.
>
> "There is no way to guarantee a contiguous ringbuffer block using
> multiple printk() calls.
>
> "The console_lock usage should be removed."
>
> https://lore.kernel.org/lkml/87frsh33xp.fsf@jogness.linutronix.de/
>
> Do that.
>
> Reported-by: syzbot+6cebc1af246fe020a2f0@syzkaller.appspotmail.com
> References: https://lore.kernel.org/dri-devel/00000000000026c1ff061cd0de12@google.com/
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Fixes: a8f354284304 ("bcachefs: bch2_print_string_as_lines()")

Reviewed-by: John Ogness <john.ogness@linutronix.de>

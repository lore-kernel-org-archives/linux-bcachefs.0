Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B115728B3EF
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Jul 2025 21:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752699837; cv=none; b=HNCL89Z4ifIPtTkAjhLuKoSpoEub/0bPab0uOaAtFRFnDnyL09X9ul5Dz8neSwjE/FAIAgaX/qx19yE0l6MEIQFcnLqgtYgWmAmpgB3Q/NHHd9bTt6gL26FVeOGpgHaHxljsfW/Rg9oLAlPw1Fk3MvI2VwKnMMwU44PxzXjOK50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752699837; c=relaxed/simple;
	bh=6EOXMOA1NB4cUxYIjjhGSAERjSo8LyGy8TklcB3h9eY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BkB+tA/ck4iqv7MH1mT1to6001k297e6LDXZC6wyWQceLUU/Jk8OZtdHX6ZrePhgcC53BJX6n3P71hD363Czs6s6Q9UEBf/sNKgAF71uLK8QTvN18pyOArOsW+bQO3RD7+YFaaC/NoGIXgYldOZg1xvYfdtQZy/zn9mRQlEH2aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SCq6mC3Q; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SCq6mC3Q"
Date: Wed, 16 Jul 2025 17:03:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752699831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B4gplD0odo3a/jaHZ42OOw/KCL1brXsuc8Cc4E6uuyI=;
	b=SCq6mC3QplNwQjfolHFUDfZnwCggq6vB9B7UlZtVKUi4yo4iamgGxOtK0TL0w3bllkZF6Q
	4Dbzs8NPcleZW9ft9abNOo5NXrGvTLiOQstjtRg+XOUS8wUdWA3T0FrMEbj36BgAKc/d0R
	PrIdnT/SdfAgfnbq56R9rU6peBmx3Rg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: convert clock.c to CLASS/guards
Message-ID: <7qr2cduhq5hqns5m4j2qmhpqcv7mahtxwsh7cofztwtbytxzet@d5hwxckffzz4>
References: <c0fa6a9b-5000-4a68-a1f1-9dd1a00be998@sabinyo.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0fa6a9b-5000-4a68-a1f1-9dd1a00be998@sabinyo.mountain>
X-Migadu-Flow: FLOW_OUT

On Wed, Jul 16, 2025 at 02:39:01PM -0500, Dan Carpenter wrote:
> Hello Kent Overstreet,
> 
> Commit 7ede8fc514bb ("bcachefs: convert clock.c to CLASS/guards")
> from Jul 14, 2025 (linux-next), leads to the following Smatch static
> checker warning:

Thanks! Applying the following:

commit db91c9d5ab0845566fa7c3de57f9992e894ab43c
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Jul 16 17:02:31 2025 -0400

    fixup! bcachefs: convert clock.c to CLASS/guards
    
    Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
    Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

diff --git a/fs/bcachefs/clock.c b/fs/bcachefs/clock.c
index 5185794f8754..1c6d0cdca3c5 100644
--- a/fs/bcachefs/clock.c
+++ b/fs/bcachefs/clock.c
@@ -21,7 +21,7 @@ static const struct min_heap_callbacks callbacks = {
 
 void bch2_io_timer_add(struct io_clock *clock, struct io_timer *timer)
 {
-	guard(spinlock)(&clock->timer_lock);
+	spin_lock(&clock->timer_lock);
 
 	if (time_after_eq64((u64) atomic64_read(&clock->now), timer->expire)) {
 		spin_unlock(&clock->timer_lock);
@@ -31,9 +31,11 @@ void bch2_io_timer_add(struct io_clock *clock, struct io_timer *timer)
 
 	for (size_t i = 0; i < clock->timers.nr; i++)
 		if (clock->timers.data[i] == timer)
-			return;
+			goto out;
 
 	BUG_ON(!min_heap_push(&clock->timers, &timer, &callbacks, NULL));
+out:
+	spin_unlock(&clock->timer_lock);
 }
 
 void bch2_io_timer_del(struct io_clock *clock, struct io_timer *timer)

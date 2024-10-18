Received: from smtp.carlthompson.net (charon.carlthompson.net [45.77.7.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF9620ADDB
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 17:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.77.7.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729273083; cv=none; b=M66untg/Qx3N7tFaQm+qjMRjKgIXmizceelOJnKmgnVcTOAz0P3su0EjKEsKiZlEQsrsUQMLMqaRb0ZmzsLUUdZfOD9biMBdbIUaqI6bPQZfssWokJoJFGqz9cuKtUqSFUk/p3xQxjOT/mCxLKjvUfWHjB5JyQ4BvKuZ6BcK9IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729273083; c=relaxed/simple;
	bh=7my7mmiDlpivKY4NGnjS3y1oqsKdy5AdL+88F2iFTS4=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=amlT1iDOGdIC9ZUt6I9VrSipSV9LoGsiaT6EnNfWzTiUlIbgkgT8Bq9Ej6t5GZDWHMR0Q2h9uZMM0qI+nR9GPJAgbGeQt8PgLZSqMkIB1tY4189H6M05wDBjS+f5uGEa3VxsgZsLlS5ocNl/l3zxDvJ5eGuEjf52mTrwfPZJaD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=carlthompson.net; spf=pass smtp.mailfrom=carlthompson.net; arc=none smtp.client-ip=45.77.7.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=carlthompson.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlthompson.net
Received: from mail.carlthompson.net (mail.home [10.35.20.252])
	(Authenticated sender: cet@carlthompson.net)
	by smtp.carlthompson.net (Postfix) with ESMTPSA id B1DF73019529C;
	Fri, 18 Oct 2024 10:37:54 -0700 (PDT)
Date: Fri, 18 Oct 2024 10:37:54 -0700 (PDT)
From: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
To: Christopher Snowhill <chris@kode54.net>,
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Message-ID: <537913254.1059.1729273074517@mail.carlthompson.net>
In-Reply-To: <D4YS7TRT48VG.3LCDBSZGAVBSZ@kode54.net>
References: <873903780.802.1729054276600@mail.carlthompson.net>
 <46uitwudetmmygddpxufepddca7azsim6trqj4o2ivsccdeavz@uztkfyqtjgks>
 <1823582410.854.1729153747302@mail.carlthompson.net>
 <xcdedhwtm4aajc4fhpb2d2urtvss7bxxzdtt2hw73hewjgr2o5@4vyurjq5v5mq>
 <724749266.890.1729156527639@mail.carlthompson.net>
 <6hoo4ruf7fzgjyx5t4vazuj6bi7fx6ahmoof4wbuc3d6xeolmq@c4n7gvcj7bfv>
 <884724407.902.1729158319260@mail.carlthompson.net>
 <tklgk7y5drm5idjqogdccdciodtgwwjuaa6ziel5uxezeaws7u@fwbthprkau3e>
 <504302838.942.1729183773058@mail.carlthompson.net>
 <D4YS7TRT48VG.3LCDBSZGAVBSZ@kode54.net>
Subject: Re: Another bcachefs version downgrade bug
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.6-Rev53
X-Originating-Client: open-xchange-appsuite


> On 2024-10-18 1:17 AM PDT Christopher Snowhill <chris@kode54.net> wrote:

> ...

> FYI, 6.9 was first released in May, and is already EOL now. In fact, so
> is 6.10, at 6.10.14.

I'm on 6.9.4 which was released in June. It's not really by choice; there are some nasty stability issues in the amdgpu driver in 6.10 and 6.11 which cause my laptop to hang multiple times per day if I use a graphical environment under them.

> There are no LTS kernels with bcachefs support yet
> at this point. All further development is going into 6.12 now, with bug
> fixes being backported into 6.11.

True. I understand that and accept it. I am not at all suggesting that Kent should make fixes for unsupported kernels. I'm just reporting a bug. But I also think that this sort of issue is one that really, **REALLY** should not happen in the first place. A filesystem silently modifying itself so that it no longer works on earlier kernels without warning is a very bad thing in my opinion. There should be processes in place to catch that sort of problem **before** a new kernel is released. And remember this isn't a one-time thing. It's happened before.

I'd also say that a filesystem design that requires that an older driver be able to successfully automatically discover and undo random on-disk modifications automatically made by a newer driver is probably a bad design (my personal opinion). It's sounds great until it doesn't work (as in this case). And I mean that as constructive criticism and not something that Kent should take personally. I think that particular design decision should be reevaluated.

It's just dumb luck that in this case the older kernel is no longer supported so it doesn't need to be fixed.

As for my particular case, I should probably see if I can get the older, stable amdgpu driver to compile under the current kernel. Barring that, I should see if I can get the current bcachefs driver to compile under the older kernel. I guess I'll find time to do that this evening.

> ...

You make some good points.

Thanks,
Carl

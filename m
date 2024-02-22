Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CAE7CF32
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Feb 2024 12:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708606140; cv=none; b=GWDVtgzqtOdwXpcNNjKAUNaNEhy9baH3qbsL1+uH3TByMu6Zmg0NqacprFJlMXJ3zTwSqOhYPdM2LOk+yRMkbuBFeIAQJT+ixlKLr2Ssei5FrnjxZ+jl/YA0SRTlVUMnrcC/y7uOdwnR5Tiegi2+KQXvx3NzJIuZvMYXSV+ANVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708606140; c=relaxed/simple;
	bh=IaZnxBsuLBFhLCtq4o+sFHyJl6jTMn3zf5TloDU0gxU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=URu3MoEA4cLksaG2e1PYZ242svylSbKtmn0rINnjIjiPKNKwBB2MSq35quVk7bipRviCYF45hb5sUi7k+EkUQGSUMcaBvz6m02LUHH0YwTsdpy7ySXr6T722KpiWSbtxBzEGqcg7KZzlU6HlPjByIfq8+VF+dkdltjMAo+9CstI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=fll1RrOO; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="fll1RrOO"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-563cb3ba9daso8096137a12.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 22 Feb 2024 04:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1708606137; x=1709210937; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IFwr9ha9a/GO5zeQAiQ5BbOipoVYz0stbyW2PYDXp3k=;
        b=fll1RrOO7XDrUfc5NNSLxz60HeekCbr1nrS34Ikie3pwl0++yp9qhLuyYzJYuYXNqI
         Uu+9xnchOtP9xOujSO3RFSI4ySdeN7GoYp8ycmSkWXcNPLwmd2f/ru2dTCB3mj01D8gE
         Nh25l644A0xVM2kBAwJR0PnomXBWj4u3Ss9j0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708606137; x=1709210937;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IFwr9ha9a/GO5zeQAiQ5BbOipoVYz0stbyW2PYDXp3k=;
        b=u/xeb0/bfUXiJlQKyttjHoU7Qa0OIoIIBNJyJkIICDjwJ7J4XMXoW3qwS+2IX4uQWD
         CoePtAKVXPAp/iLTbgBrS6XJy5K5JI4PF8+IyWEGWVVnVxak/nosCzSPG3LQETIS2GMi
         aSd2glrJ8tYzmKOQHVp9hWmkuGVqv8/iBUCI8yNQ0Gqmy7zbzGU/K3VIapRubeooIbMR
         z+YkSKSRvoStNaz5CsPeiy7nqqjQIlnGEm0EIjhyJ05TkZZnwuT3X5a7XD4N/+Dr1iM7
         8QvYgQVmWlU1xvqaK9a0HK6GsrmzgkLnvIdHCkQdmtCg95+e0jlhd6ArTpXQSEfsPr5d
         W/Jg==
X-Forwarded-Encrypted: i=1; AJvYcCWxoysxnfMgjVOeMrPc5TbjlT9krLGqg3PfY2NBRAvXzA4TQxxt9lUZeeqBvbVL8U5T3EjFKdHNc3k9i+JGyI2r/TmGPoPbSiS3oh1o9jI=
X-Gm-Message-State: AOJu0Yy4cNCPt0sJsjrYuLTTzTOqRpC3wV0aQ7C7HYJAWJA8D15AIGRm
	X8SNukkVyrxQlqucp9UY5hGdpYe32v63QbOrH40C0ssstzTQmqe/EO7BsmojYUg899ZUk3vpqHd
	9eBY9KsRaISEs6JsezoEhAnesavq+0g4MQ6ix7Q==
X-Google-Smtp-Source: AGHT+IFcJq6G1W4GM/8Xx0ldjd6icR0JuT2f4svLMCyrSjNeTeZkiYryyGjJrI/Z7YxDp/vI8lMF+gdExOLZezH1T1w=
X-Received: by 2002:a17:906:c0a:b0:a3f:6513:1489 with SMTP id
 s10-20020a1709060c0a00b00a3f65131489mr2350336ejf.55.1708606137154; Thu, 22
 Feb 2024 04:48:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2uvhm6gweyl7iyyp2xpfryvcu2g3padagaeqcbiavjyiis6prl@yjm725bizncq>
 <CAJfpeguBzbhdcknLG4CjFr12_PdGo460FSRONzsYBKmT9uaSMA@mail.gmail.com>
 <20240221210811.GA1161565@perftesting> <CAJfpegucM5R_pi_EeDkg9yPNTj_esWYrFd6vG178_asram0=Ew@mail.gmail.com>
 <w534uujga5pqcbhbc5wad7bdt5lchxu6gcmwvkg6tdnkhnkujs@wjqrhv5uqxyx> <20240222110138.ckai4sxiin3a74ku@quack3>
In-Reply-To: <20240222110138.ckai4sxiin3a74ku@quack3>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 22 Feb 2024 13:48:45 +0100
Message-ID: <CAJfpegtUZ4YWhYqqnS_BcKKpwhHvdUsQPQMf4j49ahwAe2_AXQ@mail.gmail.com>
Subject: Re: [Lsf-pc] [LSF TOPIC] statx extensions for subvol/snapshot
 filesystems & more
To: Jan Kara <jack@suse.cz>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Josef Bacik <josef@toxicpanda.com>, 
	linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, 
	linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 22 Feb 2024 at 12:01, Jan Kara <jack@suse.cz> wrote:

> I think for "unique inode identifier" we don't even have to come up with
> new APIs. The file handle + fsid pair is an established way to do this,

Why not uuid?

fsid seems to be just a degraded uuid.   We can do better with statx
and/or statmount.

> fanotify successfully uses this as object identifier and Amir did quite
> some work for this to be usable for vast majority of filesystems (including

Vast majority != all.   Also even uuid is just a statistically unique
identifier, while st_dev was guaranteed to be unique (but not
persistent, like uuid).

If we are going to start fixing userspace, then we better make sure to
use the right interfaces, that won't have issues in the future.

Thanks,
Miklos

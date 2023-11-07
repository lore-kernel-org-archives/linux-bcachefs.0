Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9832ADF72
	for <linux-bcachefs@vger.kernel.org>; Tue,  7 Nov 2023 15:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xInuXvyf"
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [IPv6:2001:41d0:1004:224b::bd])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD28319B4
	for <linux-bcachefs@vger.kernel.org>; Tue,  7 Nov 2023 07:13:08 -0800 (PST)
Date: Tue, 7 Nov 2023 10:13:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699369986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fivl1xVncnuJXES58n5N6pB2YrNqIeXlmdgBHZgNusc=;
	b=xInuXvyfXDfkr9YjG3B9zqa/KME63ouYS1nhC0ftRNW2vyI3j4XtKusTKk8n1N0fPp+K41
	RhlVXhBWcdzD9vbCOD94AiwTCZW8MqTWkVfp14sylC2Oyc+al60PabeTnEhUG/W6qzDQa+
	Nwi/BG4WBLxFo7bZ7JpcDbIZd/gDQ3U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
Message-ID: <20231107151303.5pbby66icju4ohrq@moria.home.lan>
References: <CAGudoHGenxzk0ZqPXXi1_QDbfqQhGHu+wUwzyS6WmfkUZ1HiXA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGudoHGenxzk0ZqPXXi1_QDbfqQhGHu+wUwzyS6WmfkUZ1HiXA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Nov 05, 2023 at 01:38:49PM +0100, Mateusz Guzik wrote:
> Setup is a 24 core vm + 24G of ram, running debian 12 with top of
> master as of writing this e-mail, commit being:
> commit 1c41041124bd14dd6610da256a3da4e5b74ce6b1 (HEAD -> master,
> origin/master, origin/HEAD)
> Merge: b8cc56d0414e 9fd00df05e81
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sat Nov 4 16:25:36 2023 -1000
> 
>     Merge tag 'i3c/for-6.7' of
> git://git.kernel.org/pub/scm/linux/kernel/git/i3c/linux
> 
> I ran into it when trying to poke around at the fine-grained inode hash patch.
> 
> Reproduction instructions are here: https://people.freebsd.org/~mjg/fstree.tgz

Alright, there's a two patch series in the bcachefs-testing branch that
should fix this - it's passing tests in the CI now.

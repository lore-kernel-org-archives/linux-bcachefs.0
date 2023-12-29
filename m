Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B8212E57
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Dec 2023 19:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jY/ITena"
Date: Fri, 29 Dec 2023 14:39:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1703878761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+xnCTZmWYQbigA7l27ozobkpAkuikcFrYqh8vnxScu0=;
	b=jY/ITenaK2aJgeqHvAFeBYO/bRl0eLG5MdTgYDYrj+9/ls6pqXqvuaWcELwusJ+Zv4Cq7o
	y+WaXnjhZn7IN1yRk7Dk/k51EVgorQNzhmGcf4nHMmISEY3tS+DcnYSVaIgVnlRD+/2iFP
	2+Ey2z26KueAuyBkVs/2BpcZvGy05D0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: bcachefs can't mount filesystems with duplicate UUIDs (including
 snapshots and backups)
Message-ID: <elzmgpr2fodhgz7xr7lxrnbpfrrdw64hfo3wg2wlhgu7rdqauy@gtmjuujw6qem>
References: <2122357159.374.1703803993005@mail.carlthompson.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2122357159.374.1703803993005@mail.carlthompson.net>
X-Migadu-Flow: FLOW_OUT

On Thu, Dec 28, 2023 at 02:53:12PM -0800, Carl E. Thompson wrote:
> Hello, there is an issue (bug or missing needed feature) in bcachefs
> where it appears to be impossible to mount a bcachefs filesystem which
> has the same UUID as an already mounted filesystem. This is necessary
> in many forensic and online backup scenarios. For example, in my
> personal and professional workflows crash-consistent online backups
> are made by mounting thin LVM snapshots. This seems to be impossible
> with bcachefs because it lacks a mount option to bypass the unique UID
> test and the mount fails with an `Invalid argument` message from mount
> on the command line and a `filesystem UUID already open` message in
> the kernel log.
> 
> Other filesystems have a mount option specifically to allow this. For
> example, XFS has a `nouuid` option. I believe that bcachefs needs a
> similar option to be broadly useful, particularly for non-hobbyist use
> cases. (If it makes it easier to implement IMO for most uses if the
> new mount option to bypass the UUID check implied the `nochanges`
> option that would be fine.)
> 
> I am aware that I could just use bcachefs native snapshots instead
> (when they are proven to work reliably). However, a large part of the
> reason I use LVM is because it gives me a consistent interface for
> snapshots (and thus for backups) for all the different filesystems I
> use. Retooling to special-case for bcachefs would require a lot of
> work and testing and would remove a huge benefit of this approach.

Tricky one, because we're multi device so we have a lot of code that
actually needs the UUID for identifying which filesystem a device is in;
we probably would want it to imply -o nochanges for it to be remotely
safe.

Another item for the todo list :)

Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lm+eOp/r"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665BC197
	for <linux-bcachefs@vger.kernel.org>; Fri,  1 Dec 2023 05:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701438180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=50HuSM61ElceUb3/UIaBleGwVBOqg6F7xw3gQ+q/X+4=;
	b=Lm+eOp/r+4jLa2OfQksJjsw3A+KTQxE4KK1aHBMsL5QExaGOBWvzT7FSeYBbEJEnjkfCpS
	R8xfrBdoRq4q+snBe1WWSLVFRZItOjMnLvAkhBcSjTYU1krYI1PjMAgGkDi/l0G/Zea7cw
	1Dq5Bhg/I+qegn2ZDmCyMRfIl0HicBM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-691-OMBKkwTwM1Szd74o2Zby5A-1; Fri,
 01 Dec 2023 08:42:57 -0500
X-MC-Unique: OMBKkwTwM1Szd74o2Zby5A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FD5F381A90E;
	Fri,  1 Dec 2023 13:42:57 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.214])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B9822166B26;
	Fri,  1 Dec 2023 13:42:57 +0000 (UTC)
Date: Fri, 1 Dec 2023 08:43:52 -0500
From: Brian Foster <bfoster@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: remove sb lock and flags update on explicit
 shutdown
Message-ID: <ZWnjGOvxSLUfUos2@bfoster>
References: <20231130191711.384300-1-bfoster@redhat.com>
 <20231201020006.4i5gztfj6m2lr264@moria.home.lan>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231201020006.4i5gztfj6m2lr264@moria.home.lan>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

On Thu, Nov 30, 2023 at 09:00:06PM -0500, Kent Overstreet wrote:
> On Thu, Nov 30, 2023 at 02:17:11PM -0500, Brian Foster wrote:
> > bcachefs grabs s_umount and sets SB_RDONLY when the fs is shutdown
> > via the ioctl() interface. This has a couple issues related to
> > interactions between shutdown and freeze:
> > 
> > 1. The flags == FSOP_GOING_FLAGS_DEFAULT case is a deadlock vector
> >    because freeze_bdev() calls into freeze_super(), which also
> >    acquires s_umount.
> > 
> > 2. If an explicit shutdown occurs while the sb is frozen, SB_RDONLY
> >    alters the thaw path as if the sb was read-only at freeze time.
> >    This effectively leaks the frozen state and leaves the sb frozen
> >    indefinitely.
> > 
> > The usage of SB_RDONLY here goes back to the initial bcachefs commit
> > and AFAICT is simply historical behavior. This behavior is unique to
> > bcachefs relative to the handful of other filesystems that support
> > the shutdown ioctl(). Typically, SB_RDONLY is reserved for the
> > proper remount path, which itself is restricted from modifying
> > frozen superblocks in reconfigure_super(). Drop the unnecessary sb
> > lock and flags update bch2_ioc_goingdown() to address both of these
> > issues.
> 
> Nice, I noticed a deadlock issue recently with s_umount here but didn't
> have time to fully debug it - applied!
> 

Thanks!

Hmm.. got a reference to that observed deadlock handy? I'd be a little
cautious associating here because 1. I dont think any test tooling
currently uses the default shutdown mode for the ioctl and 2. the
non-ioctl emergency shutdown paths dont set SB_RDONLY, so shouldn't
trigger the freeze issue.

So IOW while this path was broken in the ways described in the commit
log, it still seems rather unlikely for a normal use or test case to
trigger this. It would be good to know if there's still a lingering
issue to resolve..

Brian


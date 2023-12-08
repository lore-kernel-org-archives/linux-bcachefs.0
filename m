Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oApiM/QU"
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [IPv6:2001:41d0:1004:224b::ba])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FE010F8
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Dec 2023 12:35:54 -0800 (PST)
Date: Fri, 8 Dec 2023 15:35:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702067753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J0bGZhAeaC5c5MXJtrti8m+xwfGPGu2liBkUDztOXjE=;
	b=oApiM/QUm0TkffNqoRFhgkA2Y0i7leDNdKXIvbW5B3CcH/Iy8j1s2DB/Lel8sUZf1l77IO
	fn7Hla8JLLHIDmttOVz3s1C8iUFbKJGtCPYdsZ2TUWun7jXXMDl0HroEcTu0/GlNGdZyms
	VQrUy82ZvtVhzVVTnpYq068E0bVewIM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH 2/6] bcachefs: Add ability to redirect log output
Message-ID: <20231208203551.ozvwd5lljfpveqyq@moria.home.lan>
References: <20231206203313.2197302-1-kent.overstreet@linux.dev>
 <20231206203313.2197302-3-kent.overstreet@linux.dev>
 <ZXN7bctKO+Rc/pm4@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXN7bctKO+Rc/pm4@bfoster>
X-Migadu-Flow: FLOW_OUT

On Fri, Dec 08, 2023 at 03:24:13PM -0500, Brian Foster wrote:
> On Wed, Dec 06, 2023 at 03:33:06PM -0500, Kent Overstreet wrote:
> > Upcoming patches are going to add two new ioctls for running fsck in the
> > kernel, but pretending that we're running our normal userspace fsck.
> > 
> > This patch adds some plumbing for redirecting our normal log messages
> > away from the dmesg log to a thread_with_file file descriptor - via a
> > struct log_output, which will be consumed by the fsck f_op's read method.
> > 
> > The new ioctls will allow for running fsck in the kernel against an
> > offline filesystem (without mounting it), and an online filesystem. For
> > an offline filesystem we need a way to pass in a pointer to the
> > log_output, which is done via a new hidden opts.h option.
> > 
> > For online fsck, we can set c->output directly, but only want to
> > redirect log messages from the thread running fsck - hence the new
> > c->output_filter method.
> > 
> > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> > ---
> >  fs/bcachefs/bcachefs.h | 54 +++++++++++++++++++++++++++++++-----------
> >  fs/bcachefs/opts.h     |  5 ++++
> >  fs/bcachefs/super.c    | 28 ++++++++++++++++++++++
> >  3 files changed, 73 insertions(+), 14 deletions(-)
> > 
> ...
> > diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
> > index 8526f177450a..91026dfb8c83 100644
> > --- a/fs/bcachefs/opts.h
> > +++ b/fs/bcachefs/opts.h
> > @@ -419,6 +419,11 @@ enum fsck_err_opts {
> >  	  OPT_BOOL(),							\
> >  	  BCH2_NO_SB_OPT,		false,				\
> >  	  NULL,		"Allocate the buckets_nouse bitmap")		\
> > +	x(log_output,			u64,				\
> > +	  0,								\
> > +	  OPT_UINT(0, S64_MAX),						\
> > +	  BCH2_NO_SB_OPT,		false,				\
> > +	  NULL,		"Allocate the buckets_nouse bitmap")		\
> 
> I assume you want to update the string to something more related. :)

Whoops yes :) this is an internal, completely hidden option so nothing
should ever see that, fortunately :)

Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CB7168AC
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Feb 2024 03:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708571046; cv=none; b=l6UcQu2H+dOIL9OLPXeA9cvQGNqBWwfK33EcIoLTzWbENBNnZ7R30+eD9RWJoTPMDiXSu+sJqFliLl2F5gX94Ip99AfrvkYYJRlXgkcbztRNreeHrE3WDU1HXcQSyFgt0A+TleOtOm8WSMjo5x3iqR5FCuQmMWmG8kNA9vIWTUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708571046; c=relaxed/simple;
	bh=vqXTI4wfpPaSNf+7ZdTUdEAPQroLhPZjrCBU5BkoqU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UcjL93SEjJvn6fa81TDHQ5fcIWz9Iceyh9JtD48/jSnkOLMHhmJPJsVE9JFwcCpoMWc5cGrzB1oJmBBqrWb84sczAuiEyMBJoaH5rZlJdkQaUHGbcuZhm9wLphy3nQ2oyY3znSf3CV2G7ZWKoxFN6JU9l3kOOFKBtWUe+p6YFwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=azZe8rxd; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="azZe8rxd"
Date: Wed, 21 Feb 2024 22:03:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708571039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HL7KUXiy0R0ZBfFxR6/m6dt0/O/YdzsJixxnDm9Zm8o=;
	b=azZe8rxdGLg2yR1SjUWzxGwKJ9PoFZauvvL1l/5qFnS9YZRKJZLaYDVnuR4msRI52eqJ4G
	rjPWP0wmoRjP9k1U70+7m+Fa2/IqlMd8u/zWRftbuS1l2JzrzYIyKwLJz1NDWj5GeWgnS3
	pWNc5QXI/sgRwVHTZKLwx4xsUSYUlmw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org, 
	ruanjinjie@huawei.com, chris.zjh@huawei.com
Subject: Re: [PATCH] bcachefs: intercept mountoption value for bool type
Message-ID: <sfdxvffrgdjxthrblqqc2vj2zgeuszrmo6muqkicdryx4ulzrp@wfbw4muo54ow>
References: <20240221093704.3924287-1-lihongbo22@huawei.com>
 <ZdX8ek1o6MQErZMr@bfoster>
 <if2d3bmpvm3hvkgahyn5umjdnfwrtft7567opyr6k2bmwxcf4b@gm34y24jpeqy>
 <01e26540-04b6-43b2-b8d4-6d1944475145@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01e26540-04b6-43b2-b8d4-6d1944475145@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 22, 2024 at 09:30:20AM +0800, Hongbo Li wrote:
> 
> 
> On 2024/2/22 7:51, Kent Overstreet wrote:
> > On Wed, Feb 21, 2024 at 08:36:58AM -0500, Brian Foster wrote:
> > > On Wed, Feb 21, 2024 at 05:37:04PM +0800, Hongbo Li wrote:
> > > > For mount option with bool type, the value must be 0 or 1 (See
> > > > bch2_opt_parse). But this seems does not well intercepted cause
> > > > for other value(like 2...), it returns the unexpect return code
> > > > with error message printed.
> > > > 
> > > > Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> > > > ---
> > > >   fs/bcachefs/opts.c | 2 +-
> > > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
> > > > index b1ed0b9a20d3..fe1f17830694 100644
> > > > --- a/fs/bcachefs/opts.c
> > > > +++ b/fs/bcachefs/opts.c
> > > > @@ -314,7 +314,7 @@ int bch2_opt_parse(struct bch_fs *c,
> > > >   		if (ret < 0 || (*res != 0 && *res != 1)) {
> > > >   			if (err)
> > > >   				prt_printf(err, "%s: must be bool", opt->attr.name);
> > > > -			return ret;
> > > > +			return ret < 0 ?: -EINVAL;
> > > 
> > > It might be nice for that error message to be more specific in that the
> > > bool value must be 0 or 1, but LGTM regardless:
> > 
> > Please give this a distinct private error code as well (just like we
> > discussed in the previous patch)
> > 
> Here, the -EINVAL refers to the return value of other exception branches of
> this function to keep the consistent error code of this function.
> 
> In fact, it is a bit confusing to use whether to return a private error code
> or a system error code in some functions. For example, in bch2_opt_validate,
> the two exception branches of no sector alignment and power of 2 do not
> return internal error codes.

bcachefs code should _never_ throw standard error codes; the only case I
make an exception for, and in some situations is -ENOMEM - because
generally speaking an allocation failure will emit a backtrace, and most
allocation failures we never really hit in practice and if we're OOMing,
the exact allocation is uninteresting.

But even that isn't a hard rule - I've seen bugs where the filesystem
was failing to open (i.e. mount was failing) due to a failed allocation
and we did need to know which one, and sometimes there's one allocation
hiding among the many that's way bigger than you expected - so for all
the init paths, I try to make sure we have error codes that correspond
to each allocation.

So in short: always define a distinct error code and give it the best
name you can think of 

> I don't know what the boundaries are for using private error codes.
> Generally, internal functions are passed through private error codes, but
> now I can only refer to this function context to determine the error code
> type.

The boundary is the bcachefs module boundary - generally speaking the
last line of code when we're returning to non-bcachefs code should be
the bch2_err_class() call.

Incidentally, I've been meaning to add a tracepoint so that we can
recover these error codes even when they're not logged; thanks for
bringing this up as a reminder. Doing that tonight, and writing the
following documentation:

diff --git a/Documentation/filesystems/bcachefs/errorcodes.rst b/Documentation/filesystems/bcachefs/errorcodes.rst
new file mode 100644
index 000000000000..2cccaa0ba7cd
--- /dev/null
+++ b/Documentation/filesystems/bcachefs/errorcodes.rst
@@ -0,0 +1,30 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+bcachefs private error codes
+----------------------------
+
+In bcachefs, as a hard rule we do not throw or directly use standard error
+codes (-EINVAL, -EBUSY, etc.). Instead, we define private error codes as needed
+in fs/bcachefs/errcode.h.
+
+This gives us much better error messages and makes debugging much easier. Any
+direct uses of standard error codes you see in the source code are simply old
+code that has yet to be converted - feel free to clean it up!
+
+Private error codes may subtype another error code, this allows for grouping of
+related errors that should be handled similarly (e.g. transaction restart
+errors), as well as specifying which standard error code should be returned at
+the bcachefs module boundary.
+
+At the module boundary, we use bch2_err_class() to convert to a standard error
+code; this also emits a trace event so that the original error code be
+recovered even if it wasn't logged.
+
+Do not reuse error codes! Generally speaking, a private error code should only
+be thrown in one place. That means that when we see it in a log message we can
+see, unambiguously, exactly which file and line number it was returned from.
+
+Try to give error codes names that are as reasonably descriptive of the error
+as possible. Frequently, the error will be logged at a place far removed from
+where the error was generated; good names for error codes mean much more
+descriptive and useful error messages.
diff --git a/fs/bcachefs/trace.h b/fs/bcachefs/trace.h
index 2baba5f9ad3f..cb35789d591e 100644
--- a/fs/bcachefs/trace.h
+++ b/fs/bcachefs/trace.h
@@ -1443,6 +1443,12 @@ DEFINE_EVENT(fs_str, data_update,
 	TP_ARGS(c, str)
 );
 
+TRACE_EVENT(error_downcast,
+	TP_PROTO(struct bch_fs *c, int bch_err, int std_err, unsigned long ip),
+	TP_ARGS(c, str)
+);
+
 #endif /* _TRACE_BCACHEFS_H */
 
 /* This part must be outside protection */

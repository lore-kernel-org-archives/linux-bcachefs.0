Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F04C1662E8
	for <linux-bcachefs@vger.kernel.org>; Sat,  7 Sep 2024 20:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725739408; cv=none; b=PoCu26JpLMTpvwJzFAM9JHBrhflDB/dsphS1elwQulWr+galFzxPuHQLuJjTLiy/dkYKCcU2U3dmT+EeKPY9iSl77AvUirscfS3G/S6+leFKPrFDVODa4BZjFVf+kEbnwVntqOtqge9mmt9i1H+ejM2CMMpK/p8n8/5cEeR0Y9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725739408; c=relaxed/simple;
	bh=zx1WocO6c4JCrv+SItcMNTzYko10CfLhWWZPaOOQoRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=btI6GHRQU4JS5wLYA7sSr8rDPFGrwLizZBgtQ5/Wov0PA2VmFxPPPGI0q+Cb7UDGaBd+ZHZmQStnlWIr8K0bqhTsf3r15Yaqt0wvNXhYQpkZu4OyZQ0Ed0zDQs+MpBnZ90CLpzwI3tCx0MdeIMxfIriVcxNt83crADJdWPbJI5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wanYOqga; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wanYOqga"
Date: Sat, 7 Sep 2024 16:03:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725739402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ChF2ELN1Ic1bsfN3Pf/4PZB7GKoTufMp+yUyO1znpYc=;
	b=wanYOqgaaXV/OPflRPLRS495UqmCDccYC57J9ctv5gew2ZMjahEKBRVgC/dd/jEqUe2vT0
	vWS3A807gjFFitdqRIcOWuUNagGUChVDOmgvKBdv7atrMAV1LVAo8j/LN275z9PS7EVhQF
	QnW5bnVtrgZBycZg+Pkm1HhgnW4miFk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Reed Riley <reed@riley.engineer>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: [PATCH v2] bcachefs: Replace div_u64 with div64_u64 where second
 param is u64
Message-ID: <issb2c7q4uxmnxc6phkgklphomlxljbuyyjutxfq7koeu3ukuj@uxshuswwg5lz>
References: <K-lc38swD0bEueNP7QM-SeiuQ5wMms8wsydEpirWuaAKMX3oFFI4kxWIGzqzYGcsjLzP6SmKgBASsXd8BBvg9d45rSzUo3npVyrGU5D2Tb8=@riley.engineer>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <K-lc38swD0bEueNP7QM-SeiuQ5wMms8wsydEpirWuaAKMX3oFFI4kxWIGzqzYGcsjLzP6SmKgBASsXd8BBvg9d45rSzUo3npVyrGU5D2Tb8=@riley.engineer>
X-Migadu-Flow: FLOW_OUT

On Sat, Sep 07, 2024 at 04:06:30AM GMT, Reed Riley wrote:
> Bcachefs often uses this function to divide by nanosecond times - which
> can easily cause problems when cast to u32. For example, `cat
> /sys/fs/bcachefs/*/internal/rebalance_status` would return invalid data
> in the `duration waited` field because dividing by the number of
> nanoseconds in a minute requires the divisor parameter to be u64.
> 
> Signed-off-by: Reed Riley <reed@riley.engineer>

this patch isn't applying (git am says corrupted?); a fixup would be
easiest since I already applied the first one

> ---
> fs/bcachefs/sysfs.c | 2 +-
> fs/bcachefs/util.c | 12 ++++++------
> 2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
> index f393023a3ae2..561998b2b5dc 100644
> --- a/fs/bcachefs/sysfs.c
> +++ b/fs/bcachefs/sysfs.c
> @@ -288,7 +288,7 @@ static int bch2_compression_stats_to_text(struct printbuf *out, struct bch_fs *c
> prt_tab_rjust(out);
> 
> prt_human_readable_u64(out, nr_extents
> - ? div_u64(sectors_uncompressed << 9, nr_extents)
> + ? div64_u64(sectors_uncompressed << 9, nr_extents)
> : 0);
> prt_tab_rjust(out);
> prt_newline(out);
> diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
> index 1b8554460af4..144d8df48b1e 100644
> --- a/fs/bcachefs/util.c
> +++ b/fs/bcachefs/util.c
> @@ -64,7 +64,7 @@ static int bch2_pow(u64 n, u64 p, u64 *res)
> *res = 1;
> 
> while (p--) {
> - if (*res > div_u64(U64_MAX, n))
> + if (*res > div64_u64(U64_MAX, n))
> return -ERANGE;
> *res *= n;
> }
> @@ -140,14 +140,14 @@ static int __bch2_strtou64_h(const char *cp, u64 *res)
> 
> parse_or_ret(cp, parse_unit_suffix(cp, &b));
> 
> - if (v > div_u64(U64_MAX, b))
> + if (v > div64_u64(U64_MAX, b))
> return -ERANGE;
> v *= b;
> 
> - if (f_n > div_u64(U64_MAX, b))
> + if (f_n > div64_u64(U64_MAX, b))
> return -ERANGE;
> 
> - f_n = div_u64(f_n * b, f_d);
> + f_n = div64_u64(f_n * b, f_d);
> if (v + f_n < v)
> return -ERANGE;
> v += f_n;
> @@ -360,7 +360,7 @@ void bch2_pr_time_units(struct printbuf *out, u64 ns)
> {
> const struct time_unit *u = bch2_pick_time_units(ns);
> 
> - prt_printf(out, "%llu %s", div_u64(ns, u->nsecs), u->name);
> + prt_printf(out, "%llu %s", div64_u64(ns, u->nsecs), u->name);
> }
> 
> static void bch2_pr_time_units_aligned(struct printbuf *out, u64 ns)
> @@ -477,7 +477,7 @@ void bch2_time_stats_to_text(struct printbuf *out, struct bch2_time_stats *stats
> bool is_last = eytzinger0_next(i, NR_QUANTILES) == -1;
> 
> u64 q = max(quantiles->entries[i].m, last_q);
> - prt_printf(out, "%llu ", div_u64(q, u->nsecs));
> + prt_printf(out, "%llu ", div64_u64(q, u->nsecs));
> if (is_last)
> prt_newline(out);
> last_q = q;
> --
> 2.46.0

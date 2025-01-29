Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110F98F4A
	for <linux-bcachefs@vger.kernel.org>; Wed, 29 Jan 2025 18:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738173885; cv=none; b=BCCP0AKzWZKKPOm68mB73IfHbEh8dqNQXXjkBKh7Jqo91Ec+VlE7sDwk7Z81ha42iGM/9zkp/rxtY9eBk1utGm7z8LA2esuM6g7bvooxIKPZUnWtcTJ08y0+Z56uHVw5A0aLah5hqgjTr2laTKepheJtXg4caXUsuF/LdQ30dAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738173885; c=relaxed/simple;
	bh=vGUZkzsYJzlfiCbfaQdJIp8peKxgyVJOrV+s+LvLFao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TMWt8xKw0o4WT5cwNnspl3qVoVWVQm8InQ34/f2jKdWGHkmSTqWoMNW1IvxtSHbG32kFgZEzlfxVUBPSj15504YxUuVq/1NcVk7n/CozyhOM8OvhbOmi60Ohn9sQggRZsHzh+2Q0lWj/cLvM8uDZjicLrqZ2hWMgy/Kvne6tZ+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HYYbS+Q7; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HYYbS+Q7"
Date: Wed, 29 Jan 2025 13:04:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738173880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9VBTQ1irDiGRVITmSXE+fKQ0+oae2DHults3vu8twLI=;
	b=HYYbS+Q7GOR+CavazC7KLnOa4Bd/kCOu/sV11RSNag2GojNxBtB5LZIhlzVbYA3G3OQEF7
	nTVLV6cdPrt7tcmFwHdVvTtB6t0g4r/5y1QODa2J+n3Yp04sz2u5okZc6k7BjxJebvagE4
	my97jWYC/ROSfNJ5PtDvo2dBYUSZ5xE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>, linux-bcachefs@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 11/21] bcachefs: improve the eytzinger0_find_le tests
Message-ID: <ajfehauvtid4d7pqy7o3uhe6p7buohwe542wqddkwpdq62lr4g@6cgcfpzcyag3>
References: <20250128163859.1883260-1-agruenba@redhat.com>
 <20250128163859.1883260-12-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250128163859.1883260-12-agruenba@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 28, 2025 at 05:38:48PM +0100, Andreas Gruenbacher wrote:
> Rename eytzinger0_find_test_val() to eytzinger0_find_test_le() and add a
> new eytzinger0_find_test_val() wrapper that calls it.
> 
> We have already established that the array is sorted in eytzinger order,
> so we can use the eytzinger iterator functions and check the boundary
> conditions to verify the result of eytzinger0_find_le().
> 
> Only scan the entire array if we get an incorrect result.  When we need
> to scan, use eytzinger0_for_each_prev() so that we'll stop at the
> highest matching element in the array in case there are duplicates;
> going through the array linearly wouldn't give us that.

For test code, wouldn't it be simpler to iterate over the test array,
testing with every element as a search value? There's enough corner
cases in lookup that I think it'd be worthwhile (and probably add some
extra test values, e.g. first/last emelements +1/-1).

> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/bcachefs/util.c | 41 ++++++++++++++++++++++++++++++-----------
>  1 file changed, 30 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
> index 3fe9a3b8c696..c772629783f3 100644
> --- a/fs/bcachefs/util.c
> +++ b/fs/bcachefs/util.c
> @@ -782,29 +782,48 @@ static inline int cmp_u16(const void *_l, const void *_r)
>  	return (*l > *r) - (*r > *l);
>  }
>  
> -static void eytzinger0_find_test_val(u16 *test_array, unsigned nr, u16 search)
> +static void eytzinger0_find_test_le(u16 *test_array, unsigned nr, u16 search)
>  {
> -	int i, c1 = -1, c2 = -1;
> -	ssize_t r;
> +	int r, s;
> +	bool bad;
>  
>  	r = eytzinger0_find_le(test_array, nr,
>  			       sizeof(test_array[0]),
>  			       cmp_u16, &search);
> -	if (r >= 0)
> -		c1 = test_array[r];
> +	if (r >= 0) {
> +		if (test_array[r] > search) {
> +			bad = true;
> +		} else {
> +			s = eytzinger0_next(r, nr);
> +			bad = s >= 0 && test_array[s] <= search;
> +		}
> +	} else {
> +		s = eytzinger0_last(nr);
> +		bad = s >= 0 && test_array[s] <= search;
> +	}
>  
> -	for (i = 0; i < nr; i++)
> -		if (test_array[i] <= search && test_array[i] > c2)
> -			c2 = test_array[i];
> +	if (bad) {
> +		s = -1;
> +		eytzinger0_for_each_prev(j, nr) {
> +			if (test_array[j] <= search) {
> +				s = j;
> +				break;
> +			}
> +		}
>  
> -	if (c1 != c2) {
>  		eytzinger0_for_each(j, nr)
>  			pr_info("[%3u] = %12u\n", j, test_array[j]);
> -		pr_info("find_le(%2u) -> [%2zi] = %2i should be %2i\n",
> -			i, r, c1, c2);
> +		pr_info("find_le(%12u) = %3i should be %3i\n",
> +			search, r, s);
> +		BUG();
>  	}
>  }
>  
> +static void eytzinger0_find_test_val(u16 *test_array, unsigned nr, u16 search)
> +{
> +	eytzinger0_find_test_le(test_array, nr, search);
> +}
> +
>  void eytzinger0_find_test(void)
>  {
>  	unsigned i, nr, allocated = 1 << 12;
> -- 
> 2.48.1
> 

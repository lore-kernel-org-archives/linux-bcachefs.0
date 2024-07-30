Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66C318E02A
	for <linux-bcachefs@vger.kernel.org>; Tue, 30 Jul 2024 22:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722378203; cv=none; b=ZwzanTwG0zWj/cT8Hu+ImF9+hGaqzXbGvHXUV1Lo9ZF7mBw+SJGEbK6jJc7/ZHKan7x7EEXFnvfWedZzWW01yIXcxlZu+83lOLWtsSRdyL2I1nLKr3e7TJnhBBXZS0abOBwtnIV4Z+quLgekt0nenZQ5wzZcNWghaiqw4huUPeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722378203; c=relaxed/simple;
	bh=sKZeBuz2Cs+rqxHCHbFkXmSPSJyYmORRPjjABIj7DWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gYTh7At7K/zxYaJ9FaVGSe8KWfr1NBefh8KHrQYIYyC3hF4JBOgayR26MMueqioAoMa6o1JAJcQ/kVzXAjrt/lHQlqgDGkN99ERSLjFVJTrzbjWu02EDYzAm29by8bjw1vE0tPtLR7f3QWGZJGjGx479TltrQUfNSreQJsdnGik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jwl8Yj4q; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jwl8Yj4q"
Date: Tue, 30 Jul 2024 18:23:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1722378191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/Hy/Wj90t7dt6E+9SwbyI79oumyLOw/2Yn6NkQWzueg=;
	b=jwl8Yj4qriXajtAaBTY6u4/szy3O1T/Rw8Iqrjo+LHtZX8Gyrl/AC4rNbD0MiG+UolKXCv
	4ANjnDNXETM0PbQ68UTnmYtueNH78P0iFKFNj49CGqFKse3iOl2YBm4jlqMDYH7k0IITwt
	y9HlHLrESvQYBvXOAc0qbfGP8LeVjzU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: linux-bcachefs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [bug report] bcachefs: Kill opts.buckets_nouse
Message-ID: <x3nici64pxcqqhcngceu2nbtemc64bbirss7fbaeuxk7orjwuc@oxixb5xee5n2>
References: <31ed13c7-7a14-4693-a9cc-fdb078a3c412@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31ed13c7-7a14-4693-a9cc-fdb078a3c412@stanley.mountain>
X-Migadu-Flow: FLOW_OUT

On Tue, Jul 30, 2024 at 02:45:17PM GMT, Dan Carpenter wrote:
> Hello Kent Overstreet,
> 
> Commit ffcbec607613 ("bcachefs: Kill opts.buckets_nouse") from Apr 6,
> 2024 (linux-next), leads to the following Smatch static checker
> warning:
> 
> 	fs/bcachefs/super.c:1202 bch2_dev_free()
> 	warn: 'ca->buckets_nouse' double freed

yup, that's a bug

-- >8 --
Subject: [PATCH] bcachefs: Fix double free of ca->buckets_nouse

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: ffcbec6076 ("bcachefs: Kill opts.buckets_nouse")
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 0542953a7a..6d0ce3d734 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1195,7 +1195,6 @@ static void bch2_dev_free(struct bch_dev *ca)
 	if (ca->kobj.state_in_sysfs)
 		kobject_del(&ca->kobj);
 
-	kfree(ca->buckets_nouse);
 	bch2_free_super(&ca->disk_sb);
 	bch2_dev_allocator_background_exit(ca);
 	bch2_dev_journal_exit(ca);

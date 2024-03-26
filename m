Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6852013D25D
	for <linux-bcachefs@vger.kernel.org>; Tue, 26 Mar 2024 19:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711482046; cv=none; b=dkXyglXnBAlhUyXqC9YD6czwvpijjox1wsspVVnaH2Q9rki2GbLDByh1pGQM+ZeN66CN7OkaEkC9uDd0g/B8KOQIkXvQeZpcwUBQDRfRaI4DifP+zSY3qx+sa+oCcgj3i33WsaCjMTeuJfePwDdBr4cretutPtb75N9AB9Vz2MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711482046; c=relaxed/simple;
	bh=4ZLJxdWOUMo3IU+W2Q0ODJlGdT/NVmoZik/mXLK1BTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z+g+gWXODVKoGeKu4ecKBBSGQjkr0bwAQbanAo9AFZ0iGpUUD2jgOUxIDA3gS8Mxti3cM6y1+0ZJ2chh2TZZbDTrPw01Doxfw9OPESRqWGEwBC+BAhR856RkDE1b/HS01/U+TshQSOzaa+kD8R6eiWORyh6ERQLVZ54Ixc9AZNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tfyNWNki; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tfyNWNki"
Date: Tue, 26 Mar 2024 15:40:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711482042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MBMrGRBeoCK5lhQTkCKcEr2yvitu8BqU6kFjqdit//4=;
	b=tfyNWNkiQ+lDdOHy6rxmiPPNOddySF/EZKBWbvy5ucc0HRl9MVzqc+lhh6U+tgPO0Xqj0w
	e7/ZIjHCvAVdSvKiZM5lWq3O+rMo2TG7dLcMWJDLiQFWexxHSwIak+5B1j+bGNtxrwfjPr
	Y53DzP/yW4/2sFGhrnjJjKtwnlQJPso=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: fix the count of nr_freed_pcpu after changing
 bc->freed_nonpcpu list
Message-ID: <qi575tzztivxaaau4hj553qucn5cp4wdv6ou52ruuhks3h2r6o@zasfehlnwehw>
References: <20240326040456.2587357-1-lihongbo22@huawei.com>
 <663jlo5maeoh5dctbepsrnzbk7p5fwjfqaeshhb43ujcnjccdw@22vssecpk7jx>
 <b61e1609-9a6e-4f4b-9143-83ce36f11dfa@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b61e1609-9a6e-4f4b-9143-83ce36f11dfa@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 26, 2024 at 02:04:50PM +0800, Hongbo Li wrote:
> Do you mean to add these assertions at the end of
> bkey_cached_move_to_freelist and bkey_cached_alloc?

Assertions like this I generally put in the shutdown path - would that
have caught this bug?

If it wouldn't, we could make it a debug mode assertion - probably also
randomly 1/128th of the time or somoesuch, this will be a bit of an
expensive one otherwise

> 
> On 2024/3/26 12:17, Kent Overstreet wrote:
> > On Tue, Mar 26, 2024 at 12:04:56PM +0800, Hongbo Li wrote:
> > > When allocating bkey_cached from bc->freed_pcpu list, it missed
> > > decreasing the count of nr_freed_pcpu which would cause the mismatch
> > > between the value of nr_freed_pcpu and the list items. This problem
> > > also exists in moving new bkey_cached to bc->freed_pcpu list.
> > > If these happened, the bug info may appear in
> > > bch2_fs_btree_key_cache_exit by the follow code:
> > > 
> > >     BUG_ON(list_count_nodes(&bc->freed_pcpu) != bc->nr_freed_pcpu);
> > >     BUG_ON(list_count_nodes(&bc->freed_nonpcpu) != bc->nr_freed_nonpcpu);
> > 
> > Please include the assertions too :)
> > 
> > > Fixes: c65c13f0eac6 ("bcachefs: Run btree key cache shrinker less aggressively")
> > > Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> > > ---
> > >   fs/bcachefs/btree_key_cache.c | 2 ++
> > >   1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
> > > index 581edcb0911b..e1031b9ba3f4 100644
> > > --- a/fs/bcachefs/btree_key_cache.c
> > > +++ b/fs/bcachefs/btree_key_cache.c
> > > @@ -169,6 +169,7 @@ static void bkey_cached_move_to_freelist(struct btree_key_cache *bc,
> > >   	} else {
> > >   		mutex_lock(&bc->lock);
> > >   		list_move_tail(&ck->list, &bc->freed_pcpu);
> > > +		bc->nr_freed_pcpu++;
> > >   		mutex_unlock(&bc->lock);
> > >   	}
> > >   }
> > > @@ -245,6 +246,7 @@ bkey_cached_alloc(struct btree_trans *trans, struct btree_path *path,
> > >   		if (!list_empty(&bc->freed_pcpu)) {
> > >   			ck = list_last_entry(&bc->freed_pcpu, struct bkey_cached, list);
> > >   			list_del_init(&ck->list);
> > > +			bc->nr_freed_pcpu--;
> > >   		}
> > >   		mutex_unlock(&bc->lock);
> > >   	}
> > > -- 
> > > 2.34.1
> > > 
> > 

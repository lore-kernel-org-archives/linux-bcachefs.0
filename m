Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wY46wW1o"
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F84191
	for <linux-bcachefs@vger.kernel.org>; Tue, 21 Nov 2023 08:52:46 -0800 (PST)
Date: Tue, 21 Nov 2023 11:52:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700585564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4B/wnCewUj2MOzvQkEKvanEzUiyUIozLTzXpJLDjWno=;
	b=wY46wW1oNXyz5JVOTgoFPvpHcIqvM5ooJP/C9EmdEgeN9PSBFo0JtcH1TJl7lAkhWNyzGT
	W1cz/5XXqCVy4cyVwF8huojAqZ5t437G3kaHNudY7Sw0fmQ9kibeTiDKOKBxSmuGIiOrd5
	sLxg2in22SjSMS1EzX3uPFArzxgQlzU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 16/17] bcachefs: btree write buffer now slurps keys from
 journal
Message-ID: <20231121165241.ikf3p7gqfscprgcu@moria.home.lan>
References: <20231110163157.2736111-1-kent.overstreet@linux.dev>
 <20231110163157.2736111-17-kent.overstreet@linux.dev>
 <38d4a75b-1735-ec45-75e-6b59e0d9e668@linux-m68k.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38d4a75b-1735-ec45-75e-6b59e0d9e668@linux-m68k.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 21, 2023 at 11:56:49AM +0100, Geert Uytterhoeven wrote:
> 	Hi Kent,
> 
> On Fri, 10 Nov 2023, Kent Overstreet wrote:
> > Previosuly, the transaction commit path would have to add keys to the
> > btree write buffer as a separate operation, requiring additional global
> > synchronization.
> > 
> > This patch introduces a new journal entry type, which indicates that the
> > keys need to be copied into the btree write buffer prior to being
> > written out. We switch the journal entry type back to
> > JSET_ENTRY_btree_keys prior to write, so this is not an on disk format
> > change.
> > 
> > Flushing the btree write buffer may require pulling keys out of journal
> > entries yet to be written, and quiescing outstanding journal
> > reservations; we previously added journal->buf_lock for synchronization
> > with the journal write path.
> > 
> > We also can't put strict bounds on the number of keys in the journal
> > destined for the write buffer, which means we might overflow the size of
> > the preallocated buffer and have to reallocate - this introduces a
> > potentially fatal memory allocation failure. This is something we'll
> > have to watch for, if it becomes an issue in practice we can do
> > additional mitigation.
> > 
> > The transaction commit path no longer has to explicitly check if the
> > write buffer is full and wait on flushing; this is another performance
> > optimization. Instead, when the btree write buffer is close to full we
> > change the journal watermark, so that only reservations for journal
> > reclaim are allowed.
> > 
> > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> 
> Thanks for your patch, which is the closest match to commit
> 9e5a6c7797b240f1 ("bcachefs: btree write buffer now slurps keys from
> journal") in next-20231121.
> 
> > fs/bcachefs/btree_write_buffer.c       | 507 ++++++++++++++++---------
> 
> The committed version has lots of changes, including:
> 
> ++              for (struct wb_key_ref *n = i + 1; n < min(i + 4, &darray_top(wb->sorted)); n++)
> ++                      prefetch(&wb->flushing.keys.data[n->idx]);
> 
> which requires the inclusion if <linux/prefetch.h>, as reported by
> kernel test robot <lkp@intel.com> for arc[1], and by
> noreply@ellerman.id.au for m68k.

It's fixed in the current version of my for-next branch (noticed when I
imported the code into -tools).

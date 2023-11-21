Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB659CA
	for <linux-bcachefs@vger.kernel.org>; Tue, 21 Nov 2023 02:56:51 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed40:6bd9:a79:1d00:5285])
	by michel.telenet-ops.be with bizsmtp
	id Cywq2B0010Wid3g06ywqC7; Tue, 21 Nov 2023 11:56:50 +0100
Received: from geert (helo=localhost)
	by ramsan.of.borg with local-esmtp (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1r5OQz-009vPv-VG;
	Tue, 21 Nov 2023 11:56:49 +0100
Date: Tue, 21 Nov 2023 11:56:49 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 16/17] bcachefs: btree write buffer now slurps keys from
 journal
In-Reply-To: <20231110163157.2736111-17-kent.overstreet@linux.dev>
Message-ID: <38d4a75b-1735-ec45-75e-6b59e0d9e668@linux-m68k.org>
References: <20231110163157.2736111-1-kent.overstreet@linux.dev> <20231110163157.2736111-17-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

 	Hi Kent,

On Fri, 10 Nov 2023, Kent Overstreet wrote:
> Previosuly, the transaction commit path would have to add keys to the
> btree write buffer as a separate operation, requiring additional global
> synchronization.
>
> This patch introduces a new journal entry type, which indicates that the
> keys need to be copied into the btree write buffer prior to being
> written out. We switch the journal entry type back to
> JSET_ENTRY_btree_keys prior to write, so this is not an on disk format
> change.
>
> Flushing the btree write buffer may require pulling keys out of journal
> entries yet to be written, and quiescing outstanding journal
> reservations; we previously added journal->buf_lock for synchronization
> with the journal write path.
>
> We also can't put strict bounds on the number of keys in the journal
> destined for the write buffer, which means we might overflow the size of
> the preallocated buffer and have to reallocate - this introduces a
> potentially fatal memory allocation failure. This is something we'll
> have to watch for, if it becomes an issue in practice we can do
> additional mitigation.
>
> The transaction commit path no longer has to explicitly check if the
> write buffer is full and wait on flushing; this is another performance
> optimization. Instead, when the btree write buffer is close to full we
> change the journal watermark, so that only reservations for journal
> reclaim are allowed.
>
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

Thanks for your patch, which is the closest match to commit
9e5a6c7797b240f1 ("bcachefs: btree write buffer now slurps keys from
journal") in next-20231121.

> fs/bcachefs/btree_write_buffer.c       | 507 ++++++++++++++++---------

The committed version has lots of changes, including:

++              for (struct wb_key_ref *n = i + 1; n < min(i + 4, &darray_top(wb->sorted)); n++)
++                      prefetch(&wb->flushing.keys.data[n->idx]);

which requires the inclusion if <linux/prefetch.h>, as reported by
kernel test robot <lkp@intel.com> for arc[1], and by
noreply@ellerman.id.au for m68k.

[1]
https://lore.kernel.org/all/202311211650.4gRNvqfL-lkp@intel.com

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds

Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A4313793E
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Jun 2024 18:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717783814; cv=none; b=MOtqPlwnRvSERQGsQO5cJe6Im5T7/FDJd7xFUgD+Bk2ODKPOF2mR3atzPeiPIik7Ye9TIEHR1yVjIiD9iji2H6VU/iHFgiZybZyqXkf6OG1oa0pVFzuChSS780MrkuYPHjSWY0Sfx2RZublADEEkIhFi4dC7lf7yR2nAO2+35rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717783814; c=relaxed/simple;
	bh=rZ8lLJVb3ERGu0R0WJMuTm/Jhxl4hefpgc5za38gDGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RioGMBZpg5hLhYIPeRpB2ffHLZaBEyG74EPlp0/EqjYWpW8vuiQC7aBK5cR+YlD3ifb7vDdUcNyiBa0ULhXFFVHJfXNMVgDDnOVNiipBjOr+38zNyQhdDiJUd27C/LeGm0AfVe33c6CKhkSUNtUVNm8OlWM78BI7RAr9xDv2Tj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZVjN8H7A; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZVjN8H7A"
X-Envelope-To: mjguzik@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717783810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5tW9kN488xPZS+PBUDx9QiOLvj9iFRQiSjR5QCDWMhE=;
	b=ZVjN8H7AuFFuiCn63XBS4G8yXon1kG+KIXzwuvbc8ku4Mv/+ZXkbUCBiZV5Qm8PKd5lRTH
	V9HY2+7j8dPz7JlE5Q693QHo43TTkDGkSTRrcC6ntF6OoEFLOAnGFcdQzRAInFUsHsK3Dt
	9HGkGcRTG0dei/JXzvfWiKMEiYD2C+8=
X-Envelope-To: linux-bcachefs@vger.kernel.org
Date: Fri, 7 Jun 2024 14:10:05 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
Message-ID: <jsrnek56sgp3stom6nmkfkacsva3iphl2hbmohece2htyrtt7l@hlbezgwrf3hk>
References: <CAGudoHE1WhSSrqKbtCVhdxbPnmjGeb45mUw+gQ_ZEgMsfADu+g@mail.gmail.com>
 <nyu645ylcfo4go5bb7jyam7jvcohtjol2qz6n4kpcfdsaom4y6@yawhqfyzyudk>
 <CAGudoHFM1c2QMtbJMFCRw1YUk4p-_0GQBn9MfyFfNdxJbZqQeg@mail.gmail.com>
 <y3qdwfh7gjs6ykedg4ehrbwsiktabbtgoqloka5nnj5oatkh5k@7evginr2jhsf>
 <CAGudoHEsFHMG5UYpSyobp1zpm-eOpKdx=b7kL9NFG3_VKE8+Zg@mail.gmail.com>
 <ln4mfb5iv4kxxjcpm67szq24g6dxfdk36fsxb7shojmhg2fkf2@izeciivj46yw>
 <CAGudoHGeak9cnG+qE6=zoqbg5KiOZG+aMHksmbvwWTATKhWm-w@mail.gmail.com>
 <CAGudoHFyJ64SDwUTijSrqeDjXBO3MfFx8D8-DoMaPFEQmzzLDw@mail.gmail.com>
 <wvpgfberqgnidhzymc5gxsa45vwtrcto45ppcx6bprar5bkg4u@6tmfvbp5xeac>
 <CAGudoHFDFgAq2--dEubAV4w2ZqdqNY56SdAmmvy1nF8Z5bX6kA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGudoHFDFgAq2--dEubAV4w2ZqdqNY56SdAmmvy1nF8Z5bX6kA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 07, 2024 at 07:59:10PM +0200, Mateusz Guzik wrote:
> On Fri, Jun 7, 2024 at 7:53 PM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Fri, Jun 07, 2024 at 06:51:05PM +0200, Mateusz Guzik wrote:
> > > On Fri, Jun 7, 2024 at 6:28 PM Mateusz Guzik <mjguzik@gmail.com> wrote:
> > > >
> > > > On Fri, Jun 7, 2024 at 6:07 PM Kent Overstreet
> > > > <kent.overstreet@linux.dev> wrote:
> > > > >
> > > > > On Fri, Jun 07, 2024 at 12:10:34PM +0200, Mateusz Guzik wrote:
> > > > > > On Fri, Jun 7, 2024 at 11:13 AM Kent Overstreet
> > > > > > <kent.overstreet@linux.dev> wrote:
> > > > > > >
> > > > > > > On Fri, Jun 07, 2024 at 08:50:40AM +0200, Mateusz Guzik wrote:
> > > > > > > > On Fri, Jun 7, 2024 at 2:31 AM Kent Overstreet
> > > > > > > > <kent.overstreet@linux.dev> wrote:
> > > > > > > > >
> > > > > > > > > On Thu, Jun 06, 2024 at 08:40:50PM +0200, Mateusz Guzik wrote:
> > > > > > > > > > So I tried out bcachefs again and it once more fails to complete
> > > > > > > > > > parallel creation of 20 mln files -- processes doing the work use cpu
> > > > > > > > > > time in the kernel indefinitely.
> > > > > > > > >
> > > > > > > > > Hey thanks for the report - can you try my branch? It's behaving
> > > > > > > > > reasonable well in my testing now
> > > > > > > > >
> > > > > > > > > https://evilpiepirate.org/git/bcachefs.git bcachefs-for-upstream
> > > > > > > >
> > > > > > > > No dice, booted up top of your tree: 6.10.0-rc2-00013-gb7d8959f5ce9
> > > > > > >
> > > > > > > That commit completely fixes the lock contention on the btree key cache
> > > > > > > lock I was seeing before, are you sure that's the commit you were
> > > > > > > running?
> > > > > >
> > > > > > Yea, I have CONFIG_LOCALVERSION_AUTO=y and included part of uname -a
> > > > > > from the running kernel to indicate the commit. That's b7d8959f5ce9
> > > > > > "bcachefs: Fix reporting of freed objects from key cache shrinker".
> > > > > >
> > > > > > I also have CONFIG_BCACHEFS=y
> > > > > >
> > > > > > But to put this to bed I added this:
> > > > > > diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
> > > > > > index e73162f9af37..459f0871c9a4 100644
> > > > > > --- a/fs/bcachefs/btree_key_cache.c
> > > > > > +++ b/fs/bcachefs/btree_key_cache.c
> > > > > > @@ -821,8 +821,14 @@ static unsigned long
> > > > > > bch2_btree_key_cache_scan(struct shrinker *shrink,
> > > > > >         size_t scanned = 0, freed = 0, nr = sc->nr_to_scan;
> > > > > >         unsigned start, flags;
> > > > > >         int srcu_idx;
> > > > > > +       static bool printed;
> > > > > >
> > > > > >         mutex_lock(&bc->lock);
> > > > > > +       if (!printed) {
> > > > > > +               printk(KERN_EMERG "here\n");
> > > > > > +               printed = true;
> > > > > > +       }
> > > > > > +
> > > > > >         bc->requested_to_free += sc->nr_to_scan;
> > > > > >
> > > > > >         srcu_idx = srcu_read_lock(&c->btree_trans_barrier);
> > > > > >
> > > > > >
> > > > > > it shows up and my procs are still stuck in the kernel
> > > > > >
> > > > > > Is it a problem for you to get a similar setup to mine? It's not very
> > > > > > outlandish -- 24 cores and 24G of ram. You can probably get away with
> > > > > > both less cores and ram.
> > > > >
> > > > > I've tried with 4 GB of ram and with 24, and giving the vm 24 cores -
> > > > > your test passes for me, latest run was in 71 seconds.
> > > > >
> > > > > Host machine is a ryzen 5950x, 16 physical cores, 32 hyperthreaded - the
> > > > > lack of 24 physical cores is the only possible difference I can see. But
> > > > > I'm just not seeing the key cache lock contention anymore - I am seeing
> > > > > massive lock contention on the inode hash table lock, though.
> > > > >
> > > > > Here's a call graph profile of part of the last run. There's still a bit
> > > > > of key cache lock contention, but it's only 2% of cpu time now.
> > > > >
> > > >
> > > > Huh, it does appear fixed after all.
> > > >
> > > > I tried it out again, but this time without any of the debug. It *did*
> > > > finish, in 3 minutes. I ran it again just to be sure.
> > > > Also the stalls I was seeing while trying to poke also gone (for
> > > > example bpftrace would hang).
> > > >
> > > > The kernel with your fixes saddled with all the debug probably needed
> > > > significantly more than said 3 minutes and I concluded things went bad
> > > > before it could legitimately finish. Kind of a PEBKAC here.
> > > >
> > > > tl;dr I confirm it is fixed, thanks
> > > >
> > >
> > > While things do *work*, the walktree part of the test is very slow
> > > compared to ext4 and bcachefs, both of which do it in less than a
> > > minute.
> > > bcachefs repeatedly needs over two.
> > >
> > > mkfs.bcachefs /dev/vdb
> > > mount.bcachefs.sh -o noatime /dev/vdb /testfs
> > > sh createtrees /testfs 20
> > > while true; do sh walktrees /testfs 20; done
> > >
> > > I get times:
> > > 2.80s user 986.09s system 697% cpu 2:21.84 total
> > > 2.77s user 993.15s system 748% cpu 2:13.07 total
> > > 2.95s user 992.67s system 747% cpu 2:13.26 total
> >
> > ext4 gives me
> > WATCHDOG 300
> > mke2fs 1.47.1-rc2 (01-May-2024)
> > Discarding device blocks: done
> > Creating filesystem with 8386560 4k blocks and 41943040 inodes
> > Filesystem UUID: 4e72e045-ef0d-4d49-82d8-bc83e853a492
> > Superblock backups stored on blocks:
> >         6552, 19656, 32760, 45864, 58968, 163800, 176904, 321048, 530712,
> >         819000, 1592136, 2247336, 4095000, 4776408
> >
> > Allocating group tables: done
> > Writing inode tables: done
> > Creating journal (32768 blocks): done
> > Writing superblocks and filesystem accounting information: done
> >
> > EXT4-fs (vdb): mounted filesystem 4e72e045-ef0d-4d49-82d8-bc83e853a492 r/w with ordered data mode. Quota mode: disabled.
> >
> > createtrees
> > real    0m27.552s
> > user    0m6.678s
> > sys     4m17.175s
> >
> > walktrees
> > real    0m34.830s
> > user    0m2.266s
> > sys     10m38.617s
> >
> > and I get similar from bcachefs - except I did just have a run where
> > createtrees took ~3m with key cache lock contention spiking again, so it
> > appears that's not completely fixed.
> >
> > How are you getting sub 3s?
> 
> There is no sub 3s anything but maybe user time.
> 
> On my hw total real time walktree on bcachefs is about 2 minutes 13
> seconds for repeated runs.
> It is about 45 seconds on ext4.
> 
> Looks like my hw runs into the key cache lock thing very easily.

Ok, I misread.

Does the following patch help? I think the hammering on the key cache
lock may be correlated with the key cache being mostly empty (and it
looks like the shrinker code is behaving badly and trying very hard to
free from a mostly empty cache)

re: your inode lock contention patch series - we really just need to
convert fs/inode.c to an rhashtable.

diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
index e73162f9af37..24e88eebd23c 100644
--- a/fs/bcachefs/btree_key_cache.c
+++ b/fs/bcachefs/btree_key_cache.c
@@ -875,24 +875,22 @@ static unsigned long bch2_btree_key_cache_scan(struct shrinker *shrink,
 
 			if (test_bit(BKEY_CACHED_DIRTY, &ck->flags)) {
 				bc->skipped_dirty++;
-				goto next;
 			} else if (test_bit(BKEY_CACHED_ACCESSED, &ck->flags)) {
 				clear_bit(BKEY_CACHED_ACCESSED, &ck->flags);
 				bc->skipped_accessed++;
-				goto next;
-			} else if (bkey_cached_lock_for_evict(ck)) {
+			} else if (!bkey_cached_lock_for_evict(ck)) {
+				bc->skipped_lock_fail++;
+			} else {
 				bkey_cached_evict(bc, ck);
 				bkey_cached_free(bc, ck);
 				bc->moved_to_freelist++;
 				freed++;
-			} else {
-				bc->skipped_lock_fail++;
 			}
 
 			scanned++;
 			if (scanned >= nr)
 				break;
-next:
+
 			pos = next;
 		}
 
@@ -915,7 +913,8 @@ static unsigned long bch2_btree_key_cache_count(struct shrinker *shrink,
 	struct bch_fs *c = shrink->private_data;
 	struct btree_key_cache *bc = &c->btree_key_cache;
 	long nr = atomic_long_read(&bc->nr_keys) -
-		atomic_long_read(&bc->nr_dirty);
+		atomic_long_read(&bc->nr_dirty) -
+		128;
 
 	return max(0L, nr);
 }

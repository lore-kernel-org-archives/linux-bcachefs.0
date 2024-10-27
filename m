Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593F6F9F8
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 19:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730056569; cv=none; b=gKqfeFP+B6MpoJ6yJJ0ujbWNrZUm+QyxCK6Xh0kTofxyRV2CDMsA4LiTww0fbZCITuq6abrntb2hejBwAHZtNvt7ktRPTJORaa8FT1iHmYwv2xPLURkpJWXBhOvaY9jcTUgcxv6vn3bgvGio5/V3cHGcz2ENNzEEDSYq6jFLxeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730056569; c=relaxed/simple;
	bh=MgUv+Wl0CnMNphccEjRVVtcSIQr42qx3lkRhtJKjqh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=csquvD5fipL9/bGThXoaR4KLrEr0rAeWbbUxGFCJBIUXME18ff3dy8IvKnyZQipzLcDlZfKAUn9z4p+hPhKU1Bz68D7wOySDTNCWeyGfsgyk1IWkX4joAbrJa86C8pTEPnvGoMm7pwmlzx3ynk5kS3ncAEjwNolxLppUP/CBVmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lojUDuN4; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lojUDuN4"
Date: Sun, 27 Oct 2024 15:15:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730056562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6xqRa+1y/EtfkL88HSjsBOpbOYlfkBNwGrPgHlajZHU=;
	b=lojUDuN4Dg936vF2rFT2UrPoiu0qA46z3rKd+fs4YFdbyXMcbW5WWtRddr5f9rsASOcfsB
	YHGAAXI7ZvYf1Lo83ZsGhqcoEkBR+sfKB/TISk0wD8LVMujoW78xurzouXF4RUC3Kfcj/i
	3GHAcIAmv7XaKTxpgazAeerpcJxd770=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Piotr Zalewski <pZ010001011111@proton.me>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com, 
	Alan Huang <mmpgouride@gmail.com>
Subject: Re: [PATCH v2] bcachefs: Fix NULL ptr dereference in
 btree_node_iter_and_journal_peek
Message-ID: <2krm2aw3ndg2c4uw3peuhb6ldm32x5sri4p2lwou4tosfbzmpx@77kws7hnizdf>
References: <20241026174155.233430-3-pZ010001011111@proton.me>
 <j3aypufmcezitilxlgkfyetnonkzlkst3hx4zxr4zspfonh5pm@mwngtgo4h4vb>
 <BdSD2g3SGfWQrsTULTjViyG_t0llBh4NeIVbIE_3pvf1bWxk52ErCdP5yOErBZO3NkhyOv9Mgq2xc6CsGFliqDQrTgTwoquYKJKEUY5OE9g=@proton.me>
 <vzmzlzbxlyapymoccpniahd6kajrtumz7zenn4fuess6kta3qc@kbtsbr3lnl73>
 <KoKsgyv6vBuqwCj7ZnzZNWLYuQ_2LAfUUp3Eq8m9RkIS8hQOCpszlKj1BbYO8Md844-U-h2bmQJZtlTptr2-lKzYVdFtWy_BMejp5uPpjz4=@proton.me>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <KoKsgyv6vBuqwCj7ZnzZNWLYuQ_2LAfUUp3Eq8m9RkIS8hQOCpszlKj1BbYO8Md844-U-h2bmQJZtlTptr2-lKzYVdFtWy_BMejp5uPpjz4=@proton.me>
X-Migadu-Flow: FLOW_OUT

On Sun, Oct 27, 2024 at 07:00:07PM +0000, Piotr Zalewski wrote:
> 
> 
> 
> 
> 
> Sent with Proton Mail secure email.
> 
> On Sunday, October 27th, 2024 at 6:53 PM, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> 
> > On Sun, Oct 27, 2024 at 11:34:02AM +0000, Piotr Zalewski wrote:
> > 
> > > On Sunday, October 27th, 2024 at 2:28 AM, Kent Overstreet kent.overstreet@linux.dev wrote:
> > > 
> > > > On Sat, Oct 26, 2024 at 05:46:33PM +0000, Piotr Zalewski wrote:
> > > > 
> > > > > Add NULL check for key returned from bch2_btree_and_journal_iter_peek in
> > > > > btree_node_iter_and_journal_peek to avoid NULL ptr dereference in
> > > > > bch2_bkey_buf_reassemble.
> > > > > 
> > > > > When key returned from bch2_btree_and_journal_iter_peek is NULL it means
> > > > > that btree topology needs repair. Print error message with position at
> > > > > which node wasn't found and its parent node information. Call
> > > > > bch2_topology_error and return error code returned by it to ensure that
> > > > > topology error is handled properly.
> > > > > 
> > > > > Reported-by: syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com
> > > > > Closes: https://syzkaller.appspot.com/bug?extid=005ef9aa519f30d97657
> > > > > Fixes: 5222a4607cd8 ("bcachefs: BTREE_ITER_WITH_JOURNAL")
> > > > > Suggested-by: Alan Huang mmpgouride@gmail.com
> > > > > Suggested-by: Kent Overstreet kent.overstreet@linux.dev
> > > > > Signed-off-by: Piotr Zalewski pZ010001011111@proton.me
> > > > > ---
> > > > > 
> > > > > Notes:
> > > > > changes in v2:
> > > > > - make commit message more verbose.
> > > > > - set topology error, print error message and return
> > > > > appropriate error code.
> > > > > 
> > > > > link to v1: https://lore.kernel.org/linux-bcachefs/20241023072024.98915-3-pZ010001011111@proton.me/
> > > > > 
> > > > > fs/bcachefs/btree_iter.c | 13 +++++++++++++
> > > > > 1 file changed, 13 insertions(+)
> > > > > 
> > > > > diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
> > > > > index 15ac72b1af51..40c824779b15 100644
> > > > > --- a/fs/bcachefs/btree_iter.c
> > > > > +++ b/fs/bcachefs/btree_iter.c
> > > > > @@ -880,6 +880,18 @@ static noinline int btree_node_iter_and_journal_peek(struct btree_trans *trans,
> > > > > __bch2_btree_and_journal_iter_init_node_iter(trans, &jiter, l->b, l->iter, path->pos);
> > > > > 
> > > > > k = bch2_btree_and_journal_iter_peek(&jiter);
> > > > > + if (!k.k) {
> > > > > + struct printbuf buf = PRINTBUF;
> > > > > +
> > > > > + prt_str(&buf, "node not found at pos ");
> > > > > + bch2_bpos_to_text(&buf, path->pos);
> > > > > + prt_str(&buf, " within parent node ");
> > > > > + bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(&l->b->key));
> > > > > +
> > > > > + ret = bch2_fs_topology_error(c, "%s", buf.buf);
> > > > > + printbuf_exit(&buf);
> > > > > + goto err;
> > > > > + }
> > > > 
> > > > We'll want to add at least the btree ID and level to that.
> > > > 
> > > > Could you also look over the other places we report topology errors and
> > > > inconstencies for any commonality? btree_cache.c has some stuff, and I
> > > > think there's a helper in there that might give you the error message
> > > > you want (instead of just the btree node key), and I'd have a glance at
> > > > the topology error reporting in btree_update_interior.c and btree_gc.c
> > > > as well.
> > > 
> > > I scanned through mentioned files and some others. There are commonalities
> > > but every error message seem to be different in some way so that there is
> > > no truly common part.
> > > 
> > > Information contained is usually a mixture of:
> > > - btree id and level.
> > > - position at which node wasn't found or if it was found but something
> > > else is wrong its key info.
> > > - parent node key information.
> > > - prev/next node key info.
> > > - min/max key pos info.
> > > 
> > > Only appropriate helpers I found were (what I already used) -
> > > bch2_fs_topology_error and, in btree_iter.c, bch2_btree_path_to_text_short
> > > but there it doesn't print full parent key info just min_key pos and parent
> > > key pos so I'm not sure.
> > > 
> > > To what you already said I could also add min pos info.
> > 
> > bch2_btree_pos_to_text()?
> 
> Ah yes, I missed it - not used in many places and ending similar to 
> bpos_to_text. I will print path->pos + bch2_btree_pos_to_text() in the next
> version then.

yeah, keeping things organized is a never ending battle :)

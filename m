Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F390812B89
	for <linux-bcachefs@vger.kernel.org>; Wed, 21 Feb 2024 06:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708495293; cv=none; b=K6l6irbfepAbwp6r/q47Uuz6T+Azvyv13Ztf1Qn8qPrlcIwb1h8IhAMmkN56VfON9fMnS4xdeI7Gzoax8/d6rhs9TAcbIP34WUzwu9hnmJ79guvWqC5J8b6zdog4M5Z7GHPDGoY+mf9Tf1IrMOCRQG3rtq7OynfuGeimEj+WqKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708495293; c=relaxed/simple;
	bh=Cy2FYqun3LjZSaOKci4F+ljTCNcmKet6zvzoKmv0v0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KG6fwQj1cYQaCD6NgvjTKG6vpkmKnc1gMtWoKZyhlC2UdbKLCQ+B4aLOTxhO3tubyE6c+qsUkBERZnrHy8dfGcIT8pm5Lxi4v0sPufgil09UXDFZFijEI2YxsEsrNUHYKS6nifjidT53IcL6fNUpkaZ9uaxpRFwAPWRtRhwTDhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nttmM6A3; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nttmM6A3"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a293f2280c7so888678166b.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 20 Feb 2024 22:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708495290; x=1709100090; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sa74CEWOc/n7rY092YBpDyTZzAS6TRg98lMfDORLsTQ=;
        b=nttmM6A3E1COwK5R/HNQxL1lYmqMSPE8J+bIfXqr4G6p/n/0uBwwyqfb60lr6Q8QPv
         t7T3A7twXRTuWS9kq2vBooYqKLqv1tcZYBpAInj6tbfCjLOGwakT4KFZNQFo8Lsrvach
         ioLrodLbjD2lYjG4WXDjCbULkmIrJ1vikoRyxpZNLdeMUN0VoE0V+7Dky6A282Dt9XXt
         OQzlYsjHMsyr6ot8T7mb7H8CJxfESGg9CJSZnLzaEjwEG3JPnyE2ZRfnnQzH8eIwr6Ab
         h9ngEcDTrYIob8L621q8H8H9NNh4qVR4goTR/pAGs6rL1QByBEXJ2UrZh5ZlbmSO9P30
         vo4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708495290; x=1709100090;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sa74CEWOc/n7rY092YBpDyTZzAS6TRg98lMfDORLsTQ=;
        b=IAWBzcvZrgzaEvzM94p9p8h+YkrZZ1+BYed+gIIuAfBjyVTFi9duL2IyiBc6/pTVCZ
         Ahp2IYlu/s1+MKOB7hUrO9Qemg/GaZ64Q4/4HKs0zn0DMJFOFsm2+eI7Aug+6Yn9tviW
         rVBHNYZ9sjI2H7XeYk9xML6rawtWmCL7YryOdGeOg6Xwncm2IRHgzL9QcfrmtWsgUThX
         ubtmDmUuOHYaDGMb71PZu+bVuTfWLhRNPeaYqQZ0oKFH+9AsYdhFsECfno587UizsbuR
         s4/kp24mbTU7zZ3N+MwVptvOZ7Eko07JsDObgXpe9OvmuEa+Imbzro5cHIyN4RavNcY/
         2JuA==
X-Forwarded-Encrypted: i=1; AJvYcCW5lMyOlqPks0GG7XkA36RpFbbuBoYZeJ1VHMri4BKXgLPtoCWSe4+dWsLFIi0WWX3EQT921asrPhACnVAwpy4Q8LRALYSxMft8z6P6fGU=
X-Gm-Message-State: AOJu0YwwtGXSqINb+BLemedU+umkgEX4Bg27ZxAfADrmjlNENMKWQ8L1
	nDIRDIkeinCT9cWWRfGUbowdSbcFbpfw2aN9s53Ug59gN3ZgKdQ+ZKXo6pylVcA=
X-Google-Smtp-Source: AGHT+IFVedbpzxvhTcUkgsbNWBu9o+q2RIkD5Ub7vVmG1ej2Lo+9IhAb4gVjRdqT0843MboH3yGmRA==
X-Received: by 2002:a17:906:6bcf:b0:a3f:1df:7e5a with SMTP id t15-20020a1709066bcf00b00a3f01df7e5amr2434617ejs.18.1708495290303;
        Tue, 20 Feb 2024 22:01:30 -0800 (PST)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id vw13-20020a170907a70d00b00a3c5d10bcdbsm4624626ejc.114.2024.02.20.22.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 22:01:29 -0800 (PST)
Date: Wed, 21 Feb 2024 09:01:26 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: kent.overstreet@gmail.com, linux-bcachefs@vger.kernel.org,
	smatch@vger.kernel.org
Subject: Re: [bug report] bcachefs: missing error checks for
 bio_alloc_bioset()
Message-ID: <0833b5be-10ad-4842-a6b2-008d7ca11bf7@moroto.mountain>
References: <0c35596b-a280-40df-946c-c50574c3ce26@moroto.mountain>
 <fufpv24643xxn3a5jpfxx4wbfwlczrhjyzqkxo33be3yeb4sea@y4obfahio6ag>
 <11e692bc-4077-4e82-b680-fa86182d15d9@moroto.mountain>
 <34p5j77iamkybfexdpjslxegy74da7mjtpsssrv4mems4bo5mj@5xlpdnvm4yxz>
 <e92fc993-ab94-4f3b-9ee2-4e0ca5341720@moroto.mountain>
 <uxyjkjzbur2unpdkt5yl2bojacg4tptfj6k4zyshcyvyfun3i7@y6q267iebdgg>
 <a1d5fc7c-87ac-45f5-8f3d-5af1b7cd3614@moroto.mountain>
 <jno3abkiamnwk7nqh7ojvzvrurk2ua7q3fkhnhugsxdh5vjkbh@a43f35palmkn>
 <b1167150-77ee-414c-9858-50e8c90dbd6e@moroto.mountain>
 <oxbjbtdx4go62bkdeclz45iw2tmtumkeplillsntifhm7prjfo@q3xmjmo4ok7s>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <oxbjbtdx4go62bkdeclz45iw2tmtumkeplillsntifhm7prjfo@q3xmjmo4ok7s>

On Tue, Feb 20, 2024 at 04:26:38PM -0500, Kent Overstreet wrote:
> On Tue, Feb 20, 2024 at 02:39:35PM +0300, Dan Carpenter wrote:
> > So right now I only have two bcache warnings.  The missing error code
> > warning isn't published unfortunately...  I don't think I'm going to
> > have a lot of time to dedicate to this stuff in the up coming months
> > honestly.
> 
> Why not just put this stuff up in a dashboard? Make it easy for people
> to see the full results for their code, without nagging them with a
> separate email for every warning?
> 

Honestly, it would require quite a bit of work to do that and someone
would need to step up to fund Linaro for a project like that.  If
someone else feels like doing that, I'm happy to help them but right now
I have a bunch of other things on my plate.

> > fs/bcachefs/journal.c:575 __journal_res_get() error: uninitialized symbol 'can_discard'.
> 
> your error message seems wrong to me. If it was an uninitialized
> _symbol_, i.e. that symbol didn't exist, then the code wouldn't build.
> Instead you seem to be warning about a possibly uninitialized variable.
> 
> Yet a cursory inspection reveals the variable is initialized in every
> path before it's used, and gcc gets it right.
> 

Hm.  You're right.  I'll look into this.

> > fs/bcachefs/alloc_background.c:1751 bch2_discard_one_bucket() warn: missing error code here? 'discard_in_flight_add()' failed. 'ret' = '0'
> 
> No idea what smatch is complaining about here, we're returning either
> -EEXIST the error code of darray_push().

I don't understand.  I don't see an -EEXIST or a darray_push()... :/

fs/bcachefs/alloc_background.c
  1670  static int bch2_discard_one_bucket(struct btree_trans *trans,
  1671                                     struct btree_iter *need_discard_iter,
  1672                                     struct bpos *discard_pos_done,
  1673                                     struct discard_buckets_state *s)
  1674  {
  1675          struct bch_fs *c = trans->c;
  1676          struct bpos pos = need_discard_iter->pos;
  1677          struct btree_iter iter = { NULL };
  1678          struct bkey_s_c k;
  1679          struct bch_dev *ca;
  1680          struct bkey_i_alloc_v4 *a;
  1681          struct printbuf buf = PRINTBUF;
  1682          bool discard_locked = false;
  1683          int ret = 0;
  1684  
  1685          ca = bch_dev_bkey_exists(c, pos.inode);
  1686  
  1687          if (!percpu_ref_tryget(&ca->io_ref)) {
  1688                  bch2_btree_iter_set_pos(need_discard_iter, POS(pos.inode + 1, 0));
  1689                  return 0;
  1690          }
  1691  
  1692          discard_buckets_next_dev(c, s, ca);
  1693  
  1694          if (bch2_bucket_is_open_safe(c, pos.inode, pos.offset)) {
  1695                  s->open++;
  1696                  goto out;
  1697          }
  1698  
  1699          if (bch2_bucket_needs_journal_commit(&c->buckets_waiting_for_journal,
  1700                          c->journal.flushed_seq_ondisk,
  1701                          pos.inode, pos.offset)) {
  1702                  s->need_journal_commit++;
  1703                  s->need_journal_commit_this_dev++;
  1704                  goto out;
  1705          }
  1706  
  1707          k = bch2_bkey_get_iter(trans, &iter, BTREE_ID_alloc,
  1708                                 need_discard_iter->pos,
  1709                                 BTREE_ITER_CACHED);
  1710          ret = bkey_err(k);
  1711          if (ret)
  1712                  goto out;
  1713  
  1714          a = bch2_alloc_to_v4_mut(trans, k);
  1715          ret = PTR_ERR_OR_ZERO(a);
  1716          if (ret)
  1717                  goto out;

ret is zero

  1718  
  1719          if (BCH_ALLOC_V4_NEED_INC_GEN(&a->v)) {
  1720                  a->v.gen++;
  1721                  SET_BCH_ALLOC_V4_NEED_INC_GEN(&a->v, false);
  1722                  goto write;
  1723          }
  1724  
  1725          if (a->v.journal_seq > c->journal.flushed_seq_ondisk) {
  1726                  if (c->curr_recovery_pass > BCH_RECOVERY_PASS_check_alloc_info) {
  1727                          bch2_trans_inconsistent(trans,
  1728                                  "clearing need_discard but journal_seq %llu > flushed_seq %llu\n"
  1729                                  "%s",
  1730                                  a->v.journal_seq,
  1731                                  c->journal.flushed_seq_ondisk,
  1732                                  (bch2_bkey_val_to_text(&buf, c, k), buf.buf));
  1733                          ret = -EIO;
  1734                  }
  1735                  goto out;
  1736          }
  1737  
  1738          if (a->v.data_type != BCH_DATA_need_discard) {
  1739                  if (c->curr_recovery_pass > BCH_RECOVERY_PASS_check_alloc_info) {
  1740                          bch2_trans_inconsistent(trans,
  1741                                  "bucket incorrectly set in need_discard btree\n"
  1742                                  "%s",
  1743                                  (bch2_bkey_val_to_text(&buf, c, k), buf.buf));
  1744                          ret = -EIO;
  1745                  }
  1746  
  1747                  goto out;
  1748          }
  1749  
  1750          if (discard_in_flight_add(c, SPOS(iter.pos.inode, iter.pos.offset, true)))
  1751                  goto out;

We this goto out.

  1752  
  1753          discard_locked = true;
  1754  
  1755          if (!bkey_eq(*discard_pos_done, iter.pos) &&
  1756              ca->mi.discard && !c->opts.nochanges) {
  1757                  /*
  1758                   * This works without any other locks because this is the only
  1759                   * thread that removes items from the need_discard tree
  1760                   */
  1761                  bch2_trans_unlock_long(trans);
  1762                  blkdev_issue_discard(ca->disk_sb.bdev,
  1763                                       k.k->p.offset * ca->mi.bucket_size,
  1764                                       ca->mi.bucket_size,
  1765                                       GFP_KERNEL);
  1766                  *discard_pos_done = iter.pos;
  1767  
  1768                  ret = bch2_trans_relock_notrace(trans);
  1769                  if (ret)
  1770                          goto out;
  1771          }
  1772  
  1773          SET_BCH_ALLOC_V4_NEED_DISCARD(&a->v, false);
  1774          a->v.data_type = alloc_data_type(a->v, a->v.data_type);
  1775  write:
  1776          ret =   bch2_trans_update(trans, &iter, &a->k_i, 0) ?:
  1777                  bch2_trans_commit(trans, NULL, NULL,
  1778                                    BCH_WATERMARK_btree|
  1779                                    BCH_TRANS_COMMIT_no_enospc);
  1780          if (ret)
  1781                  goto out;
  1782  
  1783          count_event(c, bucket_discard);
  1784          s->discarded++;
  1785  out:
  1786          if (discard_locked)
  1787                  discard_in_flight_remove(c, iter.pos);
  1788          s->seen++;
  1789          bch2_trans_iter_exit(trans, &iter);
  1790          percpu_ref_put(&ca->io_ref);
  1791          printbuf_exit(&buf);
  1792          return ret;

It returns ret.

  1793  }


regards,
dan carpenter

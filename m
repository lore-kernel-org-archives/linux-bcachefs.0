Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C621E504
	for <linux-bcachefs@vger.kernel.org>; Wed, 31 Jan 2024 14:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706712738; cv=none; b=GIDjnACQVXUA+Shi7qlP5icj2Q9dGbcmlkGz0V5WKK5VOMgr8Hrg3/mKHzB3uCk0Ysc3Sy7mUVJ9td2OU+RwNiLHNkcrzEQjTnL0J7L11imd83Dh5M0Lgn+JnYGh5vPZJlCoCGmHW2L0/l5EDBMaVHbr4GpydXIRzRY/vhADAMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706712738; c=relaxed/simple;
	bh=sfhQgN7a/mG/wDl6TRELuU14BCXN5+j1oG4RbELMG0s=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=EiqS3iSDgV4HhlR69r3EEDcJGykj1WOxILBcP5tbEa8T6HUKH5WDyWY3Kcfm/whNmXzMQDWB0XMnQ+MA7gdki/1XBuS7wt9CMGRI/98Qtwy7bSbrgBr0ENDvR+kAdZYyPr2YUdLZt6xicsYm23lQ4Uzp4C3zaY3EpoRZ0cuLfGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aklkjdjR; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aklkjdjR"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-40e7065b692so53925535e9.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 31 Jan 2024 06:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706712735; x=1707317535; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rpw2RsA0Lfyo0lHb9jco3ChnEBh/7vov+66aVroSKKA=;
        b=aklkjdjRm5VjjbvJICXOilt3OfnWLWpspB9dtfCl+eU9m07zaeFWxacah2ELQnp3gE
         UCAeJ9l1fxY/G+BfyXH7lqACmDmjRR/28LsoD9eElsWY1Vvj3tDl/bksvZiw/nU3XT1e
         wVU35Dmi07Qced+t7AoAmFJ8MhhYZMOy7Gmn1m71s2T/FAr/liwOEsN27q1TgAqtfHus
         5mZNukL14IuP/JzhSN+87KNUTj+jb1zagVzRqq/U8K89WqXDFfgeadE090deE5IuyDB3
         7nr83yHqXErr40lDSYsNiT3+Z3+dGpTkca48180nKZqQN5YkE2qiEB54Ozhlf398Bu4o
         wU3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706712735; x=1707317535;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rpw2RsA0Lfyo0lHb9jco3ChnEBh/7vov+66aVroSKKA=;
        b=btz81S7xGbhEu8f5/4Ap0w37JjeR2WBoj51rQzv/5oRO7aB8FLHtNHQIES+If3s4M6
         czdsaC5yFt8XTQQoYnhc7a7rO4JGPJGwqaB684A68wDrhMqlr1VgjHhgkKp9U5iMFWaO
         tWE2xjuC27Qep0NOzQH2l6ixVrne1pp+oyJysGhmoGAM211v8Zgp5OY9omC5LPd4AF76
         0kBzG+AgeztKZ44ekNsAi6jKqoePfAMHi0TZXzo5bkuIcc42sfIYwTpTUUqQQixdop9y
         rBUEGfiPc2iGMigzHbwCMAkAVmg1YvYkvzmuCXAjPwWxTW1gtd80Ynqf/UUYJWWydMPZ
         I8hg==
X-Gm-Message-State: AOJu0Yx7CBBU/F9SMHcHWjLNRlgefbKcZSVqmeeev17kFhHJtqw03o4w
	6gcACRX2hpKc1K3MyRj4YV/Dyrt1immvo0XRI1HIHr7/qDHx3fsTfVmRED1xi/k=
X-Google-Smtp-Source: AGHT+IEt6ydH4T/ZNXF4SQhxYSxo95v0NKls9xi/Cv3sb0D1y0EU2drlBgDNAFWt0k+mJnqGiYexBQ==
X-Received: by 2002:a05:600c:45d0:b0:40f:30b:ee96 with SMTP id s16-20020a05600c45d000b0040f030bee96mr1429826wmo.37.1706712735160;
        Wed, 31 Jan 2024 06:52:15 -0800 (PST)
Received: from localhost ([102.140.226.10])
        by smtp.gmail.com with ESMTPSA id e1-20020a05600c4e4100b0040ee4f38968sm1826812wmq.2.2024.01.31.06.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 06:52:14 -0800 (PST)
Date: Wed, 31 Jan 2024 17:52:11 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: kent.overstreet@gmail.com
Cc: linux-bcachefs@vger.kernel.org
Subject: [bug report] bcachefs: missing error checks for bio_alloc_bioset()
Message-ID: <0c35596b-a280-40df-946c-c50574c3ce26@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Kent Overstreet,

The patch 1c6fdbd8f246: "bcachefs: Initial commit" from Mar 16, 2017
(linux-next), leads to the following Smatch static checker warning:

fs/bcachefs/btree_io.c:1672 bch2_btree_node_read() potential NULL container_of 'bio'
fs/bcachefs/btree_io.c:2165 __bch2_btree_node_write() potential NULL container_of 'bio_alloc_bioset()'
fs/bcachefs/ec.c:734 ec_block_io() potential NULL container_of 'bio_alloc_bioset()'
fs/bcachefs/fs-io-buffered.c:489 bch2_writepage_io_alloc() potential NULL container_of 'bio_alloc_bioset()'
fs/bcachefs/fs-io.c:81 bch2_inode_flush_nocow_writes_async() potential NULL container_of 'bio_alloc_bioset()'
fs/bcachefs/io_write.c:407 bch2_submit_wbio_replicas() potential NULL container_of 'bio_alloc_clone()'
fs/bcachefs/fs-io-direct.c:622 bch2_direct_write() potential NULL container_of 'bio'

fs/bcachefs/btree_io.c
    1628 void bch2_btree_node_read(struct btree_trans *trans, struct btree *b,
    1629                           bool sync)
    1630 {
    1631         struct bch_fs *c = trans->c;
    1632         struct extent_ptr_decoded pick;
    1633         struct btree_read_bio *rb;
    1634         struct bch_dev *ca;
    1635         struct bio *bio;
    1636         int ret;
    1637 
    1638         trace_and_count(c, btree_node_read, trans, b);
    1639 
    1640         if (bch2_verify_all_btree_replicas &&
    1641             !btree_node_read_all_replicas(c, b, sync))
    1642                 return;
    1643 
    1644         ret = bch2_bkey_pick_read_device(c, bkey_i_to_s_c(&b->key),
    1645                                          NULL, &pick);
    1646 
    1647         if (ret <= 0) {
    1648                 struct printbuf buf = PRINTBUF;
    1649 
    1650                 prt_str(&buf, "btree node read error: no device to read from\n at ");
    1651                 bch2_btree_pos_to_text(&buf, c, b);
    1652                 bch_err(c, "%s", buf.buf);
    1653 
    1654                 if (c->recovery_passes_explicit & BIT_ULL(BCH_RECOVERY_PASS_check_topology) &&
    1655                     c->curr_recovery_pass > BCH_RECOVERY_PASS_check_topology)
    1656                         bch2_fatal_error(c);
    1657 
    1658                 set_btree_node_read_error(b);
    1659                 clear_btree_node_read_in_flight(b);
    1660                 wake_up_bit(&b->flags, BTREE_NODE_read_in_flight);
    1661                 printbuf_exit(&buf);
    1662                 return;
    1663         }
    1664 
    1665         ca = bch_dev_bkey_exists(c, pick.ptr.dev);
    1666 
    1667         bio = bio_alloc_bioset(NULL,
                 ^^^^^^^^^^^^^^^^^^^^^^
No check for if bio_alloc_bioset() returns NULL.

    1668                                buf_pages(b->data, btree_buf_bytes(b)),
    1669                                REQ_OP_READ|REQ_SYNC|REQ_META,
    1670                                GFP_NOFS,
    1671                                &c->btree_bio);
--> 1672         rb = container_of(bio, struct btree_read_bio, bio);
    1673         rb->c                        = c;
    1674         rb->b                        = b;
    1675         rb->ra                        = NULL;
    1676         rb->start_time                = local_clock();
    1677         rb->have_ioref                = bch2_dev_get_ioref(ca, READ);
    1678         rb->pick                = pick;
    1679         INIT_WORK(&rb->work, btree_node_read_work);
    1680         bio->bi_iter.bi_sector        = pick.ptr.offset;
    1681         bio->bi_end_io                = btree_node_read_endio;
    1682         bch2_bio_map(bio, b->data, btree_buf_bytes(b));
    1683 
    1684         if (rb->have_ioref) {
    1685                 this_cpu_add(ca->io_done->sectors[READ][BCH_DATA_btree],
    1686                              bio_sectors(bio));
    1687                 bio_set_dev(bio, ca->disk_sb.bdev);
    1688 
    1689                 if (sync) {
    1690                         submit_bio_wait(bio);
    1691                         bch2_latency_acct(ca, rb->start_time, READ);
    1692                         btree_node_read_work(&rb->work);
    1693                 } else {
    1694                         submit_bio(bio);
    1695                 }
    1696         } else {
    1697                 bio->bi_status = BLK_STS_REMOVED;
    1698 
    1699                 if (sync)
    1700                         btree_node_read_work(&rb->work);
    1701                 else
    1702                         queue_work(c->io_complete_wq, &rb->work);
    1703         }
    1704 }

regards,
dan carpenter
